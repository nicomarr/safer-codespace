#!/bin/bash
# Verify devcontainer firewall behavior with positive and negative controls.
#
# Run this in a fresh Codespace after firewall changes. CI cannot exercise
# the firewall because init-firewall.sh skips itself when CI=true (the
# devcontainers/ci nested-docker context does not support iptables behavior
# properly), so this script provides the same pos/neg-control discipline
# manually.
#
# Usage:
#   bash tests/codespace/verify-firewall.sh
#
# Exit codes:
#   0  all checks passed
#   1  one or more checks failed
#   2  preflight failed (firewall not active)

set -uo pipefail
# Deliberately not using `set -e` — we want individual checks to fail
# without aborting the rest of the verification.

PASS_COUNT=0
FAIL_COUNT=0
FAILED_CHECKS=()

# Run a command and report whether its exit status matches expectation.
#
# Args:
#   $1 - human-readable check name
#   $2 - expected outcome: "pass" (command should exit 0) or "fail" (non-zero)
#   $3 - shell command to evaluate via bash -c
run_check() {
    local name="$1"
    local expected="$2"
    local cmd="$3"
    local actual

    printf "  %-52s " "$name"

    if bash -c "$cmd" >/dev/null 2>&1; then
        actual="pass"
    else
        actual="fail"
    fi

    if [ "$actual" = "$expected" ]; then
        echo "OK"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "FAIL (expected $expected, got $actual)"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_CHECKS+=("$name")
    fi
}

echo "=== Preflight: confirm firewall is active ==="
# Without this check, an inactive firewall would let every positive check
# pass and every negative check fail — both wrong, both confusing. Refuse
# to run unless the OUTPUT chain default policy is DROP.
if sudo iptables -L OUTPUT -n 2>/dev/null | grep -q "policy DROP"; then
    echo "  OUTPUT chain default policy: DROP (firewall active)"
else
    echo "  OUTPUT chain default policy: NOT DROP"
    echo
    echo "ERROR: firewall is not active. Run init-firewall.sh first:"
    echo "  sudo bash .devcontainer/init-firewall.sh"
    exit 2
fi

echo
echo "=== Positive controls (allowlisted destinations should succeed) ==="
# These exercise the script's allowlist: GitHub IPs (via api.github.com/meta)
# should be reachable for both HTTPS and SSH; DNS to github.com should resolve.
run_check "HTTPS to api.github.com" "pass" \
    "curl --connect-timeout 5 -fsS https://api.github.com/zen"
run_check "TCP/22 to github.com (SSH endpoint)" "pass" \
    "timeout 5 bash -c '</dev/tcp/github.com/22'"
run_check "DNS resolution of github.com" "pass" \
    "getent hosts github.com"
# Representative sample of documentation domains used by cli-tools/url_to_markdown.py.
# The full list lives in OPTIONAL_DOMAINS in .devcontainer/init-firewall.sh, grouped
# as "documentation sites for url_to_markdown.py". One check per category (Python,
# LLM/AI, cloud/enterprise) — sufficient evidence that the firewall is allowing the
# documentation tier as a whole without bloating the test suite with 24+ checks.
run_check "HTTPS to docs.python.org (Python docs)" "pass" \
    "curl --connect-timeout 5 -fsS -o /dev/null https://docs.python.org/3/"
run_check "HTTPS to docs.claude.com (LLM/AI docs)" "pass" \
    "curl --connect-timeout 5 -fsS -o /dev/null https://docs.claude.com/"
run_check "HTTPS to learn.microsoft.com (cloud/.NET docs)" "pass" \
    "curl --connect-timeout 5 -fsS -o /dev/null https://learn.microsoft.com/"

echo
echo "=== Negative controls (non-allowlisted destinations should be blocked) ==="
# These prove the firewall actually denies what it claims to deny. We use
# bash /dev/tcp probes for TCP checks (no application-layer involvement)
# to avoid ambiguity between "firewall blocked it" and "app rejected us".
run_check "HTTPS to example.com" "fail" \
    "curl --connect-timeout 5 -fsS https://example.com"
run_check "TCP/22 to 1.1.1.1 (Cloudflare, non-GitHub)" "fail" \
    "timeout 5 bash -c '</dev/tcp/1.1.1.1/22'"
run_check "TCP/22 to gitlab.com (non-GitHub host)" "fail" \
    "timeout 5 bash -c '</dev/tcp/gitlab.com/22'"
# DNS to a resolver not in /etc/resolv.conf or /run/systemd/resolve/resolv.conf
# should be blocked. 9.9.9.9 (Quad9) is a real working resolver — so if dig
# succeeds, it means the firewall didn't restrict destination. Picked Quad9
# rather than 1.1.1.1 or 8.8.8.8 because Codespaces is least likely to have
# Quad9 as its configured upstream. If your environment does, swap for another.
run_check "DNS to 9.9.9.9 (Quad9, not in resolver config)" "fail" \
    "timeout 3 dig +time=2 +tries=1 @9.9.9.9 example.com"

echo
echo "=== Summary ==="
echo "  Passed: $PASS_COUNT"
echo "  Failed: $FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
    echo
    echo "Failed checks:"
    for check_name in "${FAILED_CHECKS[@]}"; do
        echo "  - $check_name"
    done
    exit 1
fi

echo
echo "All firewall behavior checks passed."
exit 0
