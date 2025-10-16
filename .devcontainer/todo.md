# Devcontainer Firewall Setup - TODO

## Pending Tasks

### 0. Add Required Container Capabilities (CRITICAL)
**Status:** BLOCKING - Script cannot run without this

The container currently lacks `CAP_NET_ADMIN` capability required for iptables operations.

**Required devcontainer.json changes:**
```json
"runArgs": [
    "--cap-add=NET_ADMIN"
]
```

**Current capabilities:** cap_net_bind_service, cap_net_raw (insufficient)
**Missing:** CAP_NET_ADMIN (required for iptables/ipset operations)

### 1. Add Firewall Dependencies to devcontainer.json
After manual testing confirms the firewall script works correctly, add the following packages to the devcontainer configuration:

**Required Packages:**
- `iptables` - Firewall management tool
- `ipset` - IP set management for efficient rule handling
- `dnsutils` - DNS tools (provides `dig` command)
- `aggregate` - CIDR aggregation utility

**Installation Method:**
Add to `features` section or as a `postCreateCommand` in devcontainer.json:
```json
"postCreateCommand": "sudo apt-get update && sudo apt-get install -y iptables ipset dnsutils aggregate"
```

### 2. Integrate init-firewall.sh into Container Startup
Determine the best approach:
- Option A: Run as part of `postCreateCommand`
- Option B: Add as a lifecycle script
- Option C: Manual execution when needed

**Considerations:**
- Script requires sudo/root privileges
- May need to handle Docker DNS preservation
- Should validate connectivity after setup

### 3. Testing Checklist
- [x] Dependencies installed manually (iptables, ipset, dnsutils, aggregate)
- [x] Network connectivity test BEFORE firewall - all required endpoints accessible
- [x] Created disable-firewall.sh script for testing (to be removed after validation)
- [ ] Verify script runs without errors (blocked by missing CAP_NET_ADMIN)
- [ ] Confirm GitHub API access works
- [ ] Confirm blocked domains (example.com) are unreachable
- [ ] Test npm package installation
- [ ] Test VS Code marketplace access
- [ ] Test Anthropic API connectivity
- [ ] Test toggling firewall on/off with disable-firewall.sh
- [ ] Remove disable-firewall.sh after successful testing

## Test Results

### Pre-Firewall Network Connectivity (2025-10-16)
Ran `/workspaces/claude-codespace/tests/network/test_connectivity.sh`

**Results:**
- PyPI: ✓ CONNECTED
- GitHub API: ✓ CONNECTED
- GitHub Models: ✓ CONNECTED
- Anthropic API: ✓ CONNECTED
- Gemini API: ✓ CONNECTED
- npm registry: ✓ CONNECTED
- Go modules: ✓ CONNECTED
- example.com: ✓ CONNECTED (expected before firewall, should be blocked after)

All required development endpoints are accessible. Ready to apply firewall restrictions once container has CAP_NET_ADMIN capability.

## Notes
- Dependencies installed manually on: 2025-10-16
- Script location: `/workspaces/claude-codespace/.devcontainer/init-firewall.sh`
- Disable script created: `/workspaces/claude-codespace/.devcontainer/disable-firewall.sh` (temporary, for testing only)
- Branch: `feature/devcontainer-firewall`
- **Next step:** Commit current work, then update devcontainer.json and rebuild

## Cleanup Tasks (Post-Testing)
- [ ] Remove `disable-firewall.sh` from repository (testing utility only, not needed in production)
- [ ] Consider adding disable script to `.gitignore` if kept locally for development
