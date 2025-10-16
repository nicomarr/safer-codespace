#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, and pipeline failures
IFS=$'\n\t'       # Stricter word splitting

echo "Disabling firewall and restoring permissive network access..."

# 1. Extract Docker DNS info to preserve it
DOCKER_DNS_RULES=$(iptables-save -t nat | grep "127\.0\.0\.11" || true)

# 2. Set all policies to ACCEPT first (before flushing rules)
echo "Setting default policies to ACCEPT..."
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# 3. Flush all rules and delete custom chains
echo "Flushing all iptables rules..."
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# 4. Destroy the ipset
echo "Removing allowed-domains ipset..."
ipset destroy allowed-domains 2>/dev/null || true

# 5. Restore Docker DNS rules if they existed
if [ -n "$DOCKER_DNS_RULES" ]; then
    echo "Restoring Docker DNS rules..."
    iptables -t nat -N DOCKER_OUTPUT 2>/dev/null || true
    iptables -t nat -N DOCKER_POSTROUTING 2>/dev/null || true
    echo "$DOCKER_DNS_RULES" | xargs -L 1 iptables -t nat
else
    echo "No Docker DNS rules to restore"
fi

# 6. Add basic localhost rules (standard Linux networking)
echo "Adding standard localhost rules..."
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

echo "Firewall disabled successfully"
echo "Verifying network access..."

# Test that we can now reach blocked domains
if curl --connect-timeout 5 https://example.com >/dev/null 2>&1; then
    echo "✓ Verification passed - able to reach https://example.com"
else
    echo "⚠ Warning - still unable to reach https://example.com (this may be a network issue)"
fi

# Verify GitHub still works
if curl --connect-timeout 5 https://api.github.com/zen >/dev/null 2>&1; then
    echo "✓ Verification passed - able to reach https://api.github.com"
else
    echo "✗ ERROR - unable to reach https://api.github.com"
    exit 1
fi

echo ""
echo "Network firewall is now DISABLED - all outbound traffic is permitted"
