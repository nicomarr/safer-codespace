#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, and pipeline failures
IFS=$'\n\t'       # Stricter word splitting

# Skip firewall setup in CI environments
if [[ "${CI:-false}" == "true" ]]; then
    echo "Skipping firewall setup in CI environment"
    exit 0
fi

# 1. Extract Docker DNS info BEFORE any flushing
DOCKER_DNS_RULES=$(iptables-save -t nat | grep "127\.0\.0\.11" || true)

# Reset policies to ACCEPT before flushing — otherwise a re-run strips the
# ACCEPT rules while DROP remains, bricking the container on partial failure.
# See `git log` for full rationale.
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Flush existing rules and delete existing ipsets
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
ipset destroy allowed-domains 2>/dev/null || true

# 2. Selectively restore ONLY internal Docker DNS resolution
if [ -n "$DOCKER_DNS_RULES" ]; then
    echo "Restoring Docker DNS rules..."
    iptables -t nat -N DOCKER_OUTPUT 2>/dev/null || true
    iptables -t nat -N DOCKER_POSTROUTING 2>/dev/null || true
    echo "$DOCKER_DNS_RULES" | xargs -L 1 iptables -t nat
else
    echo "No Docker DNS rules to restore"
fi

# Restrict DNS egress to the resolvers actually configured for this container.
# Closes the direct DNS-tunnel exfiltration channel where a compromised agent
# encodes data in subdomain labels of queries directed at an attacker-controlled
# nameserver. Does NOT prevent exfiltration through the legitimate resolver
# chain (the upstream resolver still recurses to whatever NS the attacker's
# domain points at) — that would require application-layer DNS filtering,
# which is out of scope for an iptables-based control.
#
# Reads /etc/resolv.conf plus /run/systemd/resolve/resolv.conf (the latter
# only if present). Both are needed in environments using systemd-resolved
# as a stub: /etc/resolv.conf points at 127.0.0.53 on loopback (already
# covered by the lo rule below, but explicit allow doesn't hurt), and
# /run/systemd/resolve/resolv.conf lists the *upstream* resolvers that
# systemd-resolved forwards to — those queries leave via eth0 and hit
# OUTPUT, so they need their own allow rule.
#
# TCP/53 is included because DNS responses larger than 512 bytes (DNSSEC,
# big answer sets) fall back to TCP.
RESOLVER_FILES=("/etc/resolv.conf")
[ -r /run/systemd/resolve/resolv.conf ] && RESOLVER_FILES+=("/run/systemd/resolve/resolv.conf")
resolvers=$(cat "${RESOLVER_FILES[@]}" 2>/dev/null | awk '/^nameserver/ {print $2}' | sort -u)
if [ -z "$resolvers" ]; then
    echo "ERROR: no nameservers found in ${RESOLVER_FILES[*]} — refusing to apply firewall with no DNS path"
    exit 1
fi
echo "Allowing DNS to configured resolvers:"
for resolver in $resolvers; do
    echo "  - $resolver"
    iptables -A OUTPUT -p udp --dport 53 -d "$resolver" -j ACCEPT
    iptables -A OUTPUT -p tcp --dport 53 -d "$resolver" -j ACCEPT
done

# Note: upstream init-firewall.sh has `iptables -A INPUT -p udp --sport 53 -j
# ACCEPT` here to accept DNS responses. Removed in this fork — source ports
# are spoofable, and the ESTABLISHED,RELATED rule added later in this script
# handles return traffic correctly via connection tracking.
#
# Note: upstream also adds blanket outbound SSH rules here (TCP/22 OUTPUT, plus
# a return-traffic INPUT). Omitted in this fork — TCP/22 to any destination is
# an allowlist bypass since SSH can tunnel arbitrary traffic. SSH to GitHub
# still works via the allowed-domains ipset; other hosts require explicit
# allowlisting. See `git log` for the full rationale.
# Allow localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Create ipset with CIDR support
ipset create allowed-domains hash:net

# Fetch GitHub meta information and aggregate + add their IP ranges
echo "Fetching GitHub IP ranges..."
gh_ranges=$(curl -s https://api.github.com/meta)
if [ -z "$gh_ranges" ]; then
    echo "ERROR: Failed to fetch GitHub IP ranges"
    exit 1
fi

if ! echo "$gh_ranges" | jq -e '.web and .api and .git' >/dev/null; then
    echo "ERROR: GitHub API response missing required fields"
    exit 1
fi

echo "Processing GitHub IPs..."
while read -r cidr; do
    if [[ ! "$cidr" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}$ ]]; then
        echo "ERROR: Invalid CIDR range from GitHub meta: $cidr"
        exit 1
    fi
    echo "Adding GitHub range $cidr"
    ipset add allowed-domains "$cidr" -exist
done < <(echo "$gh_ranges" | jq -r '(.web + .api + .git)[]' | aggregate -q)

# Track optional domains that fail DNS resolution so we can surface a summary
# at the end of the log. GitHub IPs (fetched above) and api.anthropic.com are
# the only critical resolutions; everything else can fail without bricking
# the firewall.
failed_domains=()

# Resolve a domain and add its A records to the allowed-domains ipset.
# Args:
#   $1 - domain name
#   $2 - mode: "critical" (exit 1 on failure) or "optional" (warn and continue)
resolve_into_ipset() {
    local domain="$1"
    local mode="$2"
    local ips

    echo "Resolving $domain..."
    ips=$(dig +noall +answer A "$domain" | awk '$4 == "A" {print $5}')
    if [ -z "$ips" ]; then
        if [ "$mode" = "critical" ]; then
            echo "ERROR: Failed to resolve critical domain $domain"
            exit 1
        fi
        echo "WARNING: Failed to resolve $domain - skipping (firewall remains active)"
        failed_domains+=("$domain")
        return 0
    fi

    while read -r ip; do
        if [[ ! "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            echo "ERROR: Invalid IP from DNS for $domain: $ip"
            exit 1
        fi
        echo "Adding $ip for $domain"
        ipset add allowed-domains "$ip" -exist
    done < <(echo "$ips")
}

# Critical domains: failure aborts firewall setup.
CRITICAL_DOMAINS=(
    "api.anthropic.com"
)

# Optional domains: failure is logged and skipped.
#
# Two groups:
#   1. Tooling endpoints needed by the preinstalled tools (uv/pip, npm, go,
#      llm, claude-code, copilot, VS Code).
#   2. Documentation sites supported by cli-tools/url_to_markdown.py. These
#      MUST stay in sync with that script's ALLOWED_DOMAINS set — otherwise
#      the tool's whole workflow (fetch external docs into context/untrusted/
#      for human review) silently fails when the firewall is active. Doc
#      sites are low-exfil-risk targets (no general POST endpoint accepting
#      arbitrary data), so this surface increase is bounded.
OPTIONAL_DOMAINS=(
    # --- Group 1: tooling endpoints ---
    # Note: upstream Anthropic init-firewall.sh also includes `sentry.io` and
    # `statsig.com` here (Sentry error reporting, Statsig feature flags used
    # by claude-code). Omitted in this fork — both endpoints are explicitly
    # designed to ingest arbitrary client-side data, which contradicts the
    # template's stated posture of minimizing exfiltration surface. The
    # tooling continues to function; users may see periodic "no route to
    # host" errors when claude-code tries to phone home, which is the
    # firewall doing its job. Documented in README troubleshooting.
    "registry.npmjs.org"
    "marketplace.visualstudio.com"
    "vscode.blob.core.windows.net"
    "update.code.visualstudio.com"
    "pypi.org"
    "files.pythonhosted.org"
    "models.inference.ai.azure.com"
    "generativelanguage.googleapis.com"
    "proxy.golang.org"
    "sum.golang.org"
    "api.githubcopilot.com"

    # --- Group 2: documentation sites for url_to_markdown.py ---
    # Python
    "docs.python.org"
    # JavaScript / Node (pypi.org already in Group 1)
    "developer.mozilla.org"
    "docs.npmjs.com"
    "nodejs.org"
    # Other languages
    "docs.oracle.com"          # Java
    "learn.microsoft.com"      # .NET, Azure docs, etc.
    # Frameworks
    "react.dev"
    "vuejs.org"
    "flask.palletsprojects.com"
    "docs.djangoproject.com"
    # Version control & DevOps (api.github.com already covered via IP ranges)
    "docs.github.com"
    "docs.gitlab.com"
    # Databases
    "postgresql.org"
    "dev.mysql.com"
    "mongodb.com"
    # LLM / AI
    "llm.datasette.io"
    "datasette.io"
    "platform.openai.com"
    "docs.claude.com"
    "ai.google.dev"
    # Cloud provider docs
    "cloud.google.com"
    "aws.amazon.com"
    "azure.microsoft.com"
)

for domain in "${CRITICAL_DOMAINS[@]}"; do
    resolve_into_ipset "$domain" "critical"
done
for domain in "${OPTIONAL_DOMAINS[@]}"; do
    resolve_into_ipset "$domain" "optional"
done

# Surface optional-domain DNS failures at end of log for visibility
if [ ${#failed_domains[@]} -gt 0 ]; then
    echo
    echo "WARNING: ${#failed_domains[@]} optional domain(s) failed DNS resolution and were skipped:"
    for failed in "${failed_domains[@]}"; do
        echo "  - $failed"
    done
    echo "The firewall is still active; traffic to these endpoints will be blocked."
    echo
fi

# Get host IP from default route
HOST_IP=$(ip route | grep default | cut -d" " -f3)
if [ -z "$HOST_IP" ]; then
    echo "ERROR: Failed to detect host IP"
    exit 1
fi

HOST_NETWORK=$(echo "$HOST_IP" | sed "s/\.[0-9]*$/.0\/24/")
echo "Host network detected as: $HOST_NETWORK"

# Set up remaining iptables rules
iptables -A INPUT -s "$HOST_NETWORK" -j ACCEPT
iptables -A OUTPUT -d "$HOST_NETWORK" -j ACCEPT

# Set default policies to DROP first
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# First allow established connections for already approved traffic
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Then allow only specific outbound traffic to allowed domains
iptables -A OUTPUT -m set --match-set allowed-domains dst -j ACCEPT

# Explicitly REJECT all other outbound traffic for immediate feedback
iptables -A OUTPUT -j REJECT --reject-with icmp-admin-prohibited

echo "Firewall configuration complete"
echo "Verifying firewall rules..."
if curl --connect-timeout 5 https://example.com >/dev/null 2>&1; then
    echo "ERROR: Firewall verification failed - was able to reach https://example.com"
    exit 1
else
    echo "Firewall verification passed - unable to reach https://example.com as expected"
fi

# Verify GitHub API access
if ! curl --connect-timeout 5 https://api.github.com/zen >/dev/null 2>&1; then
    echo "ERROR: Firewall verification failed - unable to reach https://api.github.com"
    exit 1
else
    echo "Firewall verification passed - able to reach https://api.github.com as expected"
fi
