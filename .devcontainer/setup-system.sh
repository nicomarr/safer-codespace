#!/bin/bash
# System-level setup for the safer-codespace devcontainer.
#
# Installs the apt packages the firewall script depends on (iptables,
# ipset, dnsutils, aggregate) and then runs init-firewall.sh.
#
# Why this is a script and not inline in devcontainer.json's
# postCreateCommand: the apt step occasionally fails during Codespace
# creation due to transient Debian mirror issues or a network blip
# mid-transaction. When that happens the whole `system` entry aborts,
# the firewall doesn't get installed, and the container comes up wide
# open with the failure buried in the creation log. A small retry loop
# absorbs the common transient-failure mode; doing it in bash is
# legible, doing it in a chained JSON one-liner is not.
#
# CI handling is left to init-firewall.sh's own skip block (CI=true).
# apt-get works fine in CI, just slow occasionally — no need to skip it
# here.

set -euo pipefail

readonly APT_MAX_ATTEMPTS=3
readonly APT_BACKOFF_SECONDS=5

# Retry apt-get update + install with linear backoff.
# A failure inside the `if` test does NOT trip set -e because the
# command's exit status is being explicitly tested.
for attempt in $(seq 1 "$APT_MAX_ATTEMPTS"); do
    if sudo apt-get update && sudo apt-get install -y iptables ipset dnsutils aggregate; then
        break
    fi
    if [ "$attempt" -lt "$APT_MAX_ATTEMPTS" ]; then
        echo "apt-get attempt $attempt failed, retrying in ${APT_BACKOFF_SECONDS}s..."
        sleep "$APT_BACKOFF_SECONDS"
    else
        echo "ERROR: apt-get failed after $APT_MAX_ATTEMPTS attempts"
        exit 1
    fi
done

# Run the firewall init script. set -e ensures we don't reach this if
# apt failed all retries above.
sudo "$(dirname "$0")/init-firewall.sh"
