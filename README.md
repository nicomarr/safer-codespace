# Safer Codespace

![Experimental](https://img.shields.io/badge/status-experimental-orange)
![License](https://img.shields.io/badge/license-MIT-green)
![CI/CD](https://img.shields.io/badge/ci%2Fcd-configured-blue)


An **experimental** development environment exploring defense-in-depth approaches to mitigate **prompt injection** risks when using AI coding assistants.

> **⚠️ Security Notice:** This template uses multiple security layers (network firewall, content segregation, human review) to reduce prompt injection risks. While no approach is perfect, these controls make data exfiltration significantly harder. [Learn more about the threat model →](#understanding-the-security-model)

---

## Table of Contents

- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [What's Included](#whats-included)
- [Choosing the Right Tool](#choosing-the-right-tool)
- [Usage Guides](#usage-guides)
- [Understanding the Security Model](#understanding-the-security-model)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

---

## Quick Start

Get up and running in 3 steps:

1. **Click "Use this template"** to create your repository
2. **Open the devcontainer.** For security-sensitive work, use local Docker with a volume clone (recommended; see below). GitHub Codespaces also works one-click, but with a documented firewall caveat (see below).
3. **Start coding** with your choice of AI tool:
  ```bash
  # For complex, multi-step tasks with file access, use Claude Code
  claude
  # Or use Pi as alternative to Claude Code
  pi

  # Optional: Install SpecStory to auto-save conversations (see docs/SpecStory-Installation.md)
  specstory run --no-usage-analytics claude

  # For simple tasks, questions and text processing, use llm CLI tool
  llm "explain this error" < error.log

  # Or use the pipe syntax:
  git diff --staged | llm -s "Generate a conventional commit message from these changes"
  ```

That's it! All tools are pre-installed and the security firewall is automatically configured. (On first use, choose an `llm` model; see [Prerequisites](#prerequisites).)

### Recommended: local Docker (VS Code + Docker Desktop)

For security-sensitive work this is the supported path. The Codespaces-specific
failure class (see [KNOWN ISSUE](#troubleshooting)) does not arise with a local
filesystem, and no `GITHUB_TOKEN` is auto-injected. The firewall comes up during
postCreate, re-applies automatically on restart (see below), and
`verify-firewall.sh` should pass locally.

1. Install and start [Docker Desktop](https://www.docker.com/products/docker-desktop/), plus the VS Code [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).
2. Command Palette → **Dev Containers: Clone Repository in Container Volume...** → this repository.
3. **Start coding** with your AI tool of choice: the `claude`, `pi`, or `llm` commands shown in step 3 of Quick Start above.

**Prefer "Clone in Volume" over "Reopen in Container."** A bind mount (Reopen)
gives the container live write access to a folder on your host. Anything it
writes there (for example `.git/hooks` or modified scripts) can later execute
on your machine, outside every container boundary. A volume clone keeps the
workspace entirely inside Docker's VM, and work leaves it only via `git push`.
Push before deleting the volume; it is the only copy.

Security notes for local use:

- The firewall behaves as on Codespaces as far as `verify-firewall.sh` can
  observe: all negative controls held, allowlisted destinations reachable.
- No `GITHUB_TOKEN` is auto-injected locally, so that documented exfiltration
  channel is absent unless you authenticate tools inside the container
  yourself. Authenticate only what you need.
- The Codespaces stop-wedge (see Troubleshooting) is caused by the firewall
  blocking the Codespaces network-backed filesystem (Azure Storage). A local
  container has a local filesystem, so there is no storage backend for the
  firewall to starve and the failure class does not arise here. This is the
  main reason to prefer local Docker for security-sensitive work.
- iptables rules live in the container's network namespace and are wiped on
  every restart, but locally the firewall is re-applied automatically on
  container start via `postStartCommand` → `reapply-firewall.sh` (issue #24),
  which fails closed if it cannot complete. On Codespaces this re-apply is
  deliberately skipped (re-arming the firewall there re-triggers the storage
  wedge; see Troubleshooting), so a resumed codespace comes back unprotected
  by design. It is still good practice to confirm with
  `sudo iptables -L OUTPUT -n | head -1` (must say DROP) before trusting a
  freshly restarted container.

### Using GitHub Codespaces

Codespaces runs the same template in the browser with no local setup, but this
template's strict egress firewall is fundamentally at odds with the Codespaces
network-backed filesystem (Azure Storage): stopping a firewall-active codespace
can wedge in `ShuttingDown` for 35 minutes to several hours, and a resume after a
wedged stop can come back with the container **and** workspace destroyed
(uncommitted work lost). This is a deliberate won't-fix (see the
[KNOWN ISSUE](#troubleshooting) and issue #23), and it is why local Docker is the
recommended path for security-sensitive work. If you do use Codespaces, **commit
and push before stopping**, and note that a resumed codespace comes back without
the firewall by design.

To start: on your repository, **Code → Codespaces → Create codespace on main**,
then use the same `claude` / `pi` / `llm` tools shown in step 3 of Quick Start above.

---

## Prerequisites

Before using this template, ensure you have:

- **Required:**
  - [Docker Desktop](https://www.docker.com/products/docker-desktop/) (recommended local environment; see [Quick Start](#quick-start))
  - [GitHub account](https://github.com/signup) (to use the template and for `git`)

- **Optional (for AI features):**
  - [Anthropic API key](https://console.anthropic.com/) (for Claude Code and `llm` Claude models)
  - [GitHub Models access](https://github.com/marketplace/models) (free tier for `llm`, where available)
  - [Google AI Studio key](https://aistudio.google.com/) (for `llm` Gemini models)

**No `llm` model is set by default; choose one before first use.** The template installs plugins for **GitHub Models**, **Anthropic Claude**, and **Google Gemini**; pick a provider, add its key (`llm keys set <provider>`), then set a default from `llm models list` (`llm models default <model>`). In Codespaces, GitHub Models is the lowest-friction option because a `GITHUB_TOKEN` is auto-injected, so `github/gpt-4.1` works without a separate key. Enable only the provider you actually use: each allowlisted LLM endpoint is an exfiltration channel (see [Understanding the Security Model](#understanding-the-security-model)), so fewer is safer.

---

## What's Included

This devcontainer comes pre-configured with:

### AI Development Tools
- Anthropic's **[Claude Code](https://docs.claude.com/en/docs/claude-code)** for interactive AI assistance with file access and command execution
  - Default: Claude Code (requires Anthropic API key)
  - Plugins: File System, Shell Command Execution
  - Optional: Use with **[SpecStory](https://specstory.com/)** to auto-save conversations as markdown ([installation guide](docs/SpecStory-Installation.md))
- **[Pi](https://pi.dev)** by Mario Zechner & contributors (Earendil Works), a terminal coding harness with file access and bash execution, supporting multiple LLM providers (Claude, GPT, GitHub Copilot). In Codespaces, Pi works out of the box with GitHub Copilot; no extra authentication needed.
- **[llm](https://llm.datasette.io/)** developed by Simon Willison, A CLI tool for interacting with OpenAI, Anthropic's Claude, Google's Gemini, Meta's Llama and dozens of other Large Language Models
  - No model set by default; choose one before first use (see Prerequisites)
  - Plugins: GitHub Models, Anthropic Claude, Google Gemini

### Language Environments
- **Python 3.13** with `uv` (fast package manager) and `pip`
- **Node.js 24.x** with `npm` (pinned for Claude Code compatibility)
- **Go** (latest stable)

### Development Tools
- **[glow](https://github.com/charmbracelet/glow)** - Beautiful markdown rendering in terminal
- **[just](https://just.systems/)** - Simple command runner (like make, but better)

### Security Features
- **Network firewall** - Blocks unauthorized outbound connections (auto-configured). The allowlist covers SSH as well as HTTP/S, so `ssh` to non-allowlisted hosts is blocked. GitHub-over-SSH works out of the box because GitHub's SSH endpoints are included via the `api.github.com/meta` fetch. **DNS egress is restricted to the resolvers configured in `/etc/resolv.conf` and `/run/systemd/resolve/resolv.conf`**, closing direct DNS-tunnel exfiltration to attacker-controlled nameservers (DNS through the legitimate resolver chain is not closed; that would need application-layer DNS filtering, out of scope for an iptables-based control). **IPv6 egress is locked down** (`ip6tables` default-DROP, loopback only): the allowlist is built from IPv4 A-records only, so any v6 route would otherwise bypass the firewall entirely (issue #25).
- **Content segregation** - Separate `context/trusted/` and `context/untrusted/` directories
- **No GitHub CLI** - Intentionally excluded to prevent potential data exfiltration

### Continuous Integration
- **GitHub Actions** - Automated testing and validation
  - **Devcontainer Build** (`.github/workflows/devcontainer-build.yml`) - Validates the devcontainer builds successfully
  - **Network Connectivity** (`.github/workflows/network-connectivity-test.yml`) - Verifies required endpoints are reachable at the TCP layer from a bare runner
  - **`llm` CLI Tool Test** (`.github/workflows/llm-tool-test.yml`) - Verifies the `llm` CLI tool is installed and available models are configured
  - All workflows run on push/PR to `main` and can be manually triggered from the Actions tab
  - Note: firewall behavior cannot be validated in CI because `init-firewall.sh` skips itself when `CI=true` (the nested-docker context in `devcontainers/ci@v0.2` does not support iptables properly). Use `bash tests/codespace/verify-firewall.sh` in a fresh Codespace to verify firewall changes manually.

---

## Choosing the Right Tool

Not every task needs an AI agent. The tools in this template trade capability against risk:

- **Claude Code / Pi**: file access plus shell execution. Best for multi-step development: codebase exploration, test-driven development, refactoring across files. Also the most powerful target for prompt injection, so give them the deepest care about what they read.
- **`llm`**: text in, text out. No file access, no command execution. Use for piping CLI output (e.g. `git diff --staged | llm "write a commit message"`), explaining errors, quick code review. Damage from a compromised prompt is limited to text you explicitly provide.
- **VS Code with LLM integration**: inline edits scoped to the file you're looking at. You remain in control of what changes.
- **No AI at all**: for routine git operations, package installs, running tests, simple config changes. Faster, safer, no surprises.

---

## Usage Guides

### Claude Code

Interactive AI assistant with file access and command execution capabilities.

```bash
# Start Claude Code
claude

# Start with a prompt
claude "help me refactor this code"

# View options
claude --help
```

**Using SpecStory with Claude Code:**

SpecStory automatically saves your Claude Code conversations as clean, searchable markdown. This preserves the reasoning, decisions, and design tradeoffs behind your code as versioned, git-friendly documentation.

```bash
# Install SpecStory (optional, see installation guide)
# Follow instructions at: docs/SpecStory-Installation.md

# Run Claude Code with SpecStory (telemetry disabled; see note below)
specstory run --no-usage-analytics claude

# Your conversations are automatically saved to .specstory/
# as markdown files with timestamps and full context
```

**Note on `--no-usage-analytics`:** by default, `specstory run` sends usage telemetry to PostHog (`app.posthog.com`, served from Cloudflare). The firewall blocks those connections, which surfaces as repeated `dial tcp ...: connect: no route to host` errors in the terminal while Claude Code still runs and SpecStory still captures the conversation locally. The flag disables the telemetry calls so the log stays clean. Confirmed with the SpecStory team.

**Why use SpecStory?**
- **Preserve intent** - Capture the "why" behind code decisions
- **Reusable context** - Refer back to past conversations and reasoning
- **Team collaboration** - Share decision logs with teammates
- **Git-friendly** - Version control your design discussions
- **Local-first** - All data stays on your machine by default

For detailed documentation: https://docs.claude.com/en/docs/claude-code/overview
SpecStory documentation pages: https://docs.specstory.com/overview

### llm CLI

Command-line interface for various language models. No model is set by default, so pick a provider, add its key, and set a default (`llm models default <model>`); see [Prerequisites](#prerequisites). In Codespaces, `github/gpt-4.1` works with the auto-injected `GITHUB_TOKEN`.

```bash
# Basic usage - pipe input to llm
echo "Hello world" | llm "translate to Spanish"

# Read from file
llm "explain this code" < script.py

# Alternative: use cat to pipe file contents
cat script.py | llm "explain this code"

# Interactive chat mode
llm chat

# List available models
llm models list

# Set / change the default model (use an id from `llm models list`)
llm models default <model>

# View comprehensive help
llm --help
```

For detailed documentation: https://llm.datasette.io/

### Other Tools

**glow** - Render markdown beautifully in your terminal:
```bash
glow README.md      # View a file
glow                # Browse current directory
cat file.md | glow  # Pipe content
```

**just** - Run project-specific commands (defined in `justfile`):
```bash
just --list              # Show available commands
just command-name        # Run a command
just --show command-name # View command definition
```

---

## Understanding the Security Model

### The Threat: Prompt Injection and the "Lethal Trifecta"

When AI assistants have all three capabilities, attackers can inject malicious instructions into external content:

1. **Access to Private Data** - Read your code, files, secrets
2. **Exposure to Untrusted Content** - Process external docs, dependencies, web pages
3. **Ability to Exfiltrate Data** - Send data out via network requests to attacker-controlled servers

**Attack scenario:** Malicious instructions in documentation → AI reads your secrets → AI sends them to attacker's server.

### Approach

This template uses **multiple redundant layers** rather than relying on any single defense:

#### 1. Network Firewall (Mitigates Exfiltration)

- **Blocks all outbound traffic** except to pre-approved development endpoints
- **Allowed domains:** GitHub, npm, PyPI, Anthropic API, Google Gemini API, etc.
- **Automatically configured** on container startup
- **Validates rules** to ensure proper function
- **Fails closed:** if `init-firewall.sh` cannot complete (a network error, a
  bad precondition, or a signal such as SIGHUP from a terminal closing mid-run),
  it locks the container down (egress blocked, loopback only) instead of leaving
  it open. A security control must fail closed, not silently open. Re-run the
  script to restore normal operation; for manual re-runs, detach so a closing
  terminal cannot interrupt the apply mid-flight:
  `setsid bash .devcontainer/init-firewall.sh`.

**Test the firewall:**
```bash
tests/network/test_connectivity.sh
```

**Verify firewall behavior in a Codespace (after firewall changes):**
```bash
bash tests/codespace/verify-firewall.sh
```
Runs positive controls (HTTPS, TCP/22, DNS to allowlisted destinations should succeed) and negative controls (the same to non-allowlisted destinations should be blocked). Exits 0 only if all checks pass. CI cannot exercise this: `init-firewall.sh` skips itself when `CI=true` because `devcontainers/ci@v0.2`'s nested-docker context does not support iptables properly. After modifying `init-firewall.sh`, open a fresh Codespace on the PR branch, run the script, and paste the output into the PR description as evidence.

**Add new domains:**
Edit `.devcontainer/init-firewall.sh` and add to the domain list around line 67:
```bash
for domain in \
    "registry.npmjs.org" \
    "api.anthropic.com" \
    "your-new-domain.com" \
    # ... rest of domains
```

**Limitations:** The firewall blocks destinations, not request contents. Four gaps worth naming up front:

*Codespaces tunnel relay.* The allowlist includes GitHub's dev-tunnels service (`*.rel.tunnels.api.visualstudio.com`, "Group 3" in `init-firewall.sh`); without it `gh codespace ssh` fails and browser reconnection hangs. The tradeoff: the tunnel relays arbitrary traffic by design, so a compromised agent could open its own dev tunnel to exfiltrate. We deliberately do NOT allowlist the broader Azure wildcards GitHub lists (`*.windows.net`, `*.azureedge.net`), which would permit arbitrary-content hosting.

*Allowlisted LLM endpoints.* Endpoints such as `api.anthropic.com` and `models.inference.ai.azure.com` accept arbitrary text, so a compromised agent could POST stolen data to one. Enable only the provider you actually use (see Prerequisites) to keep this surface small.

*GitHub itself.* GitHub's IP ranges must be allowlisted for the repo to work, so with the auto-injected `GITHUB_TOKEN` an agent can `git push` to a fork, create a gist, or post comments with stolen content. See "Why No GitHub CLI?" below.

*Bounded by the container.* The `vscode` user has passwordless `sudo` (needed for setup), so a compromised agent could run `sudo iptables -F` to drop the firewall or `sudo apt install gh`. These are layers a user maintains, not enforcement against an agent already running as them.

#### 2. Content Segregation

The `context/` directory separates vetted from unvetted content:

```
context/
├── trusted/       # Human-reviewed content (safe to use)
└── untrusted/     # External docs requiring review
```

**Recommended workflow:**

1. **Fetch** external content using non-AI tools (`curl`, Jina Reader)
2. **Save** to `context/untrusted/` with descriptive filenames
3. **Review** yourself for malicious instructions:
   - "Send passwords to..."
   - "Ignore previous instructions..."
   - Suspicious URLs or commands
4. **Move** to `context/trusted/` after review
5. **Reference** only `context/trusted/` with AI agents

This ensures agents never directly process untrusted content.

#### 3. Human Review (The Critical Layer)

**Key principle:** Don't use AI to detect prompt injection attacks! Use human intelligence to review external content before providing it as context.

#### 4. Tool Selection

Choose less powerful tools when possible:
- `llm` (no file access) over Claude Code or Pi for simple tasks
- Manual commands over AI for routine operations

### Why No GitHub CLI?

The `gh` CLI is intentionally excluded from the devcontainer image. This is partial mitigation, not enforcement: `git push` to an attacker-controlled fork uses the same auto-injected `GITHUB_TOKEN` and works without `gh`. Treat the exclusion as a signal of intent and a small friction-raiser, not a closed channel. Standard `git` handles legitimate workflows; install `gh` manually with `sudo apt install gh` if needed.

### Learn More

Curated reading in `context/trusted/`:
- `simon-willison-weblog-content/`: original 2022 post coining "prompt injection", the 2025 "lethal trifecta" framing, real-world examples of attacks on major AI systems.
- `github-blog-posts/github-actions-workflow-injection-risks.md`: GitHub Actions-specific injection vectors.

---

## Troubleshooting

### Firewall Issues

**Problem:** Can't connect to a required service or an API not in the allow-list

**Solution:** Add the domain/IP to `.devcontainer/init-firewall.sh` in the allowed domains list, then rebuild the container to apply the change. To re-run the script in an already-running container without rebuilding:
```bash
sudo /workspaces/safer-codespace/.devcontainer/init-firewall.sh
```

**Problem:** `ssh` to a non-GitHub host (own server, GitLab, Bitbucket) hangs or times out

**Solution:** Outbound SSH is restricted to hosts in the firewall allowlist, not blanket-allowed. GitHub is included automatically via the `api.github.com/meta` fetch; other SSH hosts must be added explicitly. Resolve the host's IP and add it to `.devcontainer/init-firewall.sh` alongside the other optional domains, then rebuild the container. Unlike GitHub, GitLab and Bitbucket do not publish a stable meta endpoint, so their IP ranges have to be maintained manually.

**Problem:** `gh codespace ssh` fails with an RPC error, or reconnecting to a codespace hangs

**Solution:** The Codespaces dev-tunnel endpoints are blocked. The firewall allowlists `global.rel.tunnels.api.visualstudio.com` plus common regional hosts (Group 3 in `init-firewall.sh`); add your region's host if it is missing. `gh codespace ssh` also needs the `sshd` feature (included here). Existing sessions survive via the ESTABLISHED rule, so "the editor works but ssh doesn't" doesn't rule this out.

> **KNOWN ISSUE (Codespaces only).** Stopping a firewall-active codespace can wedge in `ShuttingDown` for 35 minutes to several hours, and a resume after a wedged stop can return in recovery mode with the container **and** workspace destroyed (uncommitted work lost). Cause: the firewall starves the Codespaces network-backed filesystem (Azure Storage), so uncached reads fault (`Input/output error`, or `Bus error` on mmap). Strict egress control and a network-backed filesystem are fundamentally incompatible, so we deliberately do **not** allowlist the storage backend. **For security-sensitive work, run locally (Clone in Volume)**, where this failure class cannot occur; if you must use Codespaces, **commit and push before stopping**. Full root-cause analysis, the A/B proof, and the won't-fix decision: [issue #23](https://github.com/nicomarr/safer-codespace/issues/23).

**Debugging which traffic the firewall blocks:** REJECTed packets never appear in `tcpdump -i eth0`; capture them with an NFLOG rule instead, and find the storage backend with `ss -tn | grep ESTAB`; full technique in [issue #23](https://github.com/nicomarr/safer-codespace/issues/23).

**Problem:** Periodic `no route to host` errors from `claude` or related tooling

**Solution:** Expected behavior: `sentry.io` (error reporting) and `statsig.com` (feature flags) are deliberately not allowlisted, since both ingest arbitrary client data. The tools still work; the errors are just blocked telemetry. Re-add them to `OPTIONAL_DOMAINS` in `init-firewall.sh` and rebuild if a workflow needs them.

**Problem:** an allowlisted documentation site intermittently fails to load

**Solution:** The firewall allowlists IPs from a one-time DNS snapshot, but CDN-fronted sites rotate their A-records, so the live IP can drift out of the allowlist. Re-run `init-firewall.sh` to refresh the snapshot; the doc-site allowlist (Group 2) is best-effort by design. `learn.microsoft.com` was removed as the worst offender; rationale and how to re-add it in [issue #27](https://github.com/nicomarr/safer-codespace/issues/27).

**For temporary debugging:** Disable the firewall (resets on container restart):
```bash
sudo iptables -F
sudo iptables -X
```

### Claude Code Issues

**Problem:** "Claude Code not found"

**Solution:** Node.js 25+ is not supported. This template uses Node.js 24.x. Rebuild the container.

### Pi Issues

**Problem:** Pi not found

**Solution:** Rebuild the devcontainer. Pi is installed during container build.

**Problem:** GitHub Copilot not working

**Solution:** Ensure `api.githubcopilot.com` is in the firewall allow-list and rebuild the container.

### llm Issues

**Problem:** `No key found` / "No API key configured" (e.g. running `llm` before configuring a model)

**Solution:** No model is set by default, so configure one. In Codespaces, GitHub Models works with the auto-injected `GITHUB_TOKEN`, so just set it as the default. Otherwise, set a provider key and make it the default:
```bash
# In Codespaces (token already injected), just pick the default:
llm models default github/gpt-4.1

# Anywhere else: set a provider key, list models, then set a default
llm keys set anthropic          # or: github / gemini
llm models list
llm models default <model>      # use an id from 'llm models list'
```

**Problem:** `llm` command not found

**Solution:** Rebuild the devcontainer. The `llm` tool is installed during container build.

### General Container Issues

**Problem:** Tools not installed or outdated

**Solution:** Rebuild the devcontainer:
- In VS Code: Command Palette → "Dev Containers: Rebuild Container"
- In GitHub Codespaces: Rebuild from the Codespaces menu

---

## Contributing

This is an experimental repository exploring prompt-injection mitigations, not a claim that prompt injection is solved. Bug reports, security critiques, and suggestions that fit the defense-in-depth model are welcome via GitHub Issues or PRs.

---

## License

MIT License. See [LICENSE](LICENSE).

---

Use at your own risk. Always review external content before exposing it to AI agents.