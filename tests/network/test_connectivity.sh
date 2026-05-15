#!/bin/bash
# Network connectivity test for Safer Codespace.
#
# Verifies that the endpoints required by .devcontainer/devcontainer.json's
# postCreateCommand are reachable at the TCP layer from the current environment.
# Uses bash /dev/tcp probes (same idiom as tests/codespace/verify-firewall.sh)
# rather than HTTP requests, to avoid false positives from middleboxes returning
# 403 — the previous version of this script used bare `curl -s` (no --fail)
# and so accepted 403/404 responses as "CONNECTED - TEST PASSED" while never
# emitting a non-zero exit code. The CI badge has been green by construction.
#
# Designed to run on a bare CI runner (no firewall active). Firewall behavior
# is verified separately by tests/codespace/verify-firewall.sh.
#
# Exit codes:
#   0  all required endpoints reachable at TCP layer
#   1  one or more endpoints not reachable

set -uo pipefail
# Deliberately not using `set -e` — we want individual probe failures to be
# reported and counted, not to abort the whole test.

PASS_COUNT=0
FAIL_COUNT=0
FAILED_ENDPOINTS=()

echo "=== Safer Codespace network connectivity test ==="
echo "Checking TCP/443 reachability for endpoints required by postCreateCommand..."
echo

# Format: "Display Name:host:port" — split on ':' below.
# These hosts must be reachable for the devcontainer to build and the
# preinstalled tools (uv/pip, npm, go, llm, claude-code) to function.
endpoints=(
    "PyPI:pypi.org:443"
    "GitHub API:api.github.com:443"
    "GitHub Models:models.inference.ai.azure.com:443"
    "Anthropic API:api.anthropic.com:443"
    "Gemini API:generativelanguage.googleapis.com:443"
    "npm registry:registry.npmjs.org:443"
    "Go modules:proxy.golang.org:443"
)

for endpoint in "${endpoints[@]}"; do
    name="${endpoint%%:*}"
    rest="${endpoint#*:}"
    host="${rest%%:*}"
    port="${rest#*:}"

    printf "  %-22s " "$name:"

    if timeout 5 bash -c "</dev/tcp/$host/$port" 2>/dev/null; then
        echo "OK"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "FAIL (TCP connection failed)"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_ENDPOINTS+=("$name ($host:$port)")
    fi
done

echo
echo "=== Summary ==="
echo "  Passed: $PASS_COUNT"
echo "  Failed: $FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
    echo
    echo "Failed endpoints:"
    for endpoint in "${FAILED_ENDPOINTS[@]}"; do
        echo "  - $endpoint"
    done
    exit 1
fi

echo
echo "All required endpoints reachable."
exit 0
