#!/bin/bash
set -uo pipefail
# Re-apply the egress firewall on container start (issue #24).
#
# LOCAL ONLY. On Codespaces we deliberately do NOT re-apply: the firewall blocks
# the Codespaces network-backed Azure Storage filesystem, so re-arming it on a
# resumed codespace re-triggers the stop-wedge and the container/workspace data
# loss (issue #23, closed won't-fix). A resumed codespace therefore comes back
# WITHOUT the firewall by design; run init-firewall.sh by hand only if you
# accept that tradeoff.
#
# iptables rules live in the container's network namespace, which is recreated
# on every container stop/start, so without this the firewall silently
# disappears after a restart until re-run. init-firewall.sh fails closed
# (issue #22), so a failed reapply leaves the container locked down, not open.
if [ -n "${CODESPACES:-}" ]; then
    echo "Codespaces detected - not re-applying firewall on start (see issue #23)."
    exit 0
fi

echo "Local container start - re-applying firewall (issue #24)."
exec sudo --preserve-env=GITHUB_TOKEN "$(dirname "$0")/init-firewall.sh"
