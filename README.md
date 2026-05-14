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
2. **Open in GitHub Codespaces** (or your preferred devcontainer host)
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

That's it! All tools are pre-installed and the security firewall is automatically configured.

---

## Prerequisites

Before using this template, ensure you have:

- **Required:**
  - [GitHub account](https://github.com/signup) (for Codespaces or template usage)
  - [Docker Desktop](https://www.docker.com/products/docker-desktop/) (for local devcontainer usage)

- **Optional (for AI features):**
  - [Anthropic API key](https://console.anthropic.com/) (for Claude Code and `llm` Claude models)
  - [GitHub Models access](https://github.com/marketplace/models) (free GPT-4o via `llm` - default)
  - [Google AI Studio key](https://aistudio.google.com/) (for `llm` Gemini models)

The default configuration uses **GitHub's free GPT-4o** model, so you can start immediately without any API keys.

---

## What's Included

This devcontainer comes pre-configured with:

### AI Development Tools
- Anthropic's **[Claude Code](https://docs.claude.com/en/docs/claude-code)** for interactive AI assistance with file access and command execution
  - Default: Claude Code (requires Anthropic API key)
  - Plugins: File System, Shell Command Execution
  - Optional: Use with **[SpecStory](https://specstory.com/)** to auto-save conversations as markdown ([installation guide](docs/SpecStory-Installation.md))
- **[Pi](https://pi.dev)** by Mario Zechner & contributors (Earendil Works) — a terminal coding harness with file access and bash execution, supporting multiple LLM providers (Claude, GPT, GitHub Copilot). In Codespaces, Pi works out of the box with GitHub Copilot — no extra authentication needed.
- **[llm](https://llm.datasette.io/)** developed by Simon Willison, A CLI tool for interacting with OpenAI, Anthropic's Claude, Google's Gemini, Meta's Llama and dozens of other Large Language Models
  - Default: GitHub GPT-4o (free, no API key required)
  - Plugins: Anthropic Claude, Google Gemini, GitHub Models

### Language Environments
- **Python 3.13** with `uv` (fast package manager) and `pip`
- **Node.js 24.x** with `npm` (pinned for Claude Code compatibility)
- **Go** (latest stable)

### Development Tools
- **[glow](https://github.com/charmbracelet/glow)** - Beautiful markdown rendering in terminal
- **[just](https://just.systems/)** - Simple command runner (like make, but better)

### Security Features
- **Network firewall** - Blocks unauthorized outbound connections (auto-configured). The allowlist covers SSH as well as HTTP/S, so `ssh` to non-allowlisted hosts is blocked. GitHub-over-SSH works out of the box because GitHub's SSH endpoints are included via the `api.github.com/meta` fetch.
- **Content segregation** - Separate `context/trusted/` and `context/untrusted/` directories
- **No GitHub CLI** - Intentionally excluded to prevent potential data exfiltration

### Continuous Integration
- **GitHub Actions** - Automated testing and validation
  - **Devcontainer Build** (`.github/workflows/devcontainer-build.yml`) - Validates the devcontainer builds successfully
  - **Network Connectivity** (`.github/workflows/network-connectivity-test.yml`) - Verifies required endpoints are reachable
  - **Firewall Validation** (`.github/workflows/firewall-validation.yml`) - Ensures firewall blocks unauthorized domains while allowing required endpoints
  - **`llm` CLI Tool Test** (`.github/workflows/llm-tool-test.yml`) - Verifies the `llm` CLI tool is installed and available models are configured
  - All workflows run on push/PR to `main` and can be manually triggered from the Actions tab

---

## Choosing the Right Tool

Not every task needs an AI agent. The tools in this template trade capability against risk:

- **Claude Code / Pi** — file access plus shell execution. Best for multi-step development: codebase exploration, test-driven development, refactoring across files. Also the most powerful target for prompt injection — give them the deepest care about what they read.
- **`llm`** — text in, text out. No file access, no command execution. Use for piping CLI output (e.g. `git diff --staged | llm "write a commit message"`), explaining errors, quick code review. Damage from a compromised prompt is limited to text you explicitly provide.
- **VS Code with LLM integration** — inline edits scoped to the file you're looking at. You remain in control of what changes.
- **No AI at all** — for routine git operations, package installs, running tests, simple config changes. Faster, safer, no surprises.

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

# Run Claude Code with SpecStory (telemetry disabled — see note below)
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

Command-line interface for various language models. Uses GitHub GPT-4o by default (no API key required).

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

# Change default model
llm models default claude-3-5-sonnet-latest

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

**Test the firewall:**
```bash
tests/network/test_connectivity.sh
```

**Verify firewall behavior in a Codespace (after firewall changes):**
```bash
bash tests/codespace/verify-firewall.sh
```
Runs positive controls (HTTPS, TCP/22, DNS to allowlisted destinations should succeed) and negative controls (the same to non-allowlisted destinations should be blocked). Exits 0 only if all checks pass. CI cannot exercise this — `init-firewall.sh` skips itself when `CI=true` because `devcontainers/ci@v0.2`'s nested-docker context does not support iptables properly. After modifying `init-firewall.sh`, open a fresh Codespace on the PR branch, run the script, and paste the output into the PR description as evidence.

**Add new domains:**
Edit `.devcontainer/init-firewall.sh` and add to the domain list around line 67:
```bash
for domain in \
    "registry.npmjs.org" \
    "api.anthropic.com" \
    "your-new-domain.com" \
    # ... rest of domains
```

**Limitations:** Cannot prevent exfiltration to allowed domains (e.g., GitHub). Works best with other layers.

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

The `gh` CLI is **intentionally excluded** as part of our security-first approach:

- **Risk:** Could be used to exfiltrate data via issues, PRs, or gists
- **Alternative:** Standard `git` commands handle most workflows
- **If needed:** Install manually (`sudo apt install gh`) with full awareness of the risk

### Learn More

Curated reading in `context/trusted/`:
- `simon-willison-weblog-content/` — original 2022 post coining "prompt injection", the 2025 "lethal trifecta" framing, real-world examples of attacks on major AI systems.
- `github-blog-posts/github-actions-workflow-injection-risks.md` — GitHub Actions–specific injection vectors.

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

**Problem:** "No API key configured"

**Solution:** The default GitHub GPT-4o model should work without keys. If using other models:
```bash
# Set API keys
llm keys set anthropic
llm keys set openai

# Verify models are available
llm models list
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

This is an experimental repository exploring prompt-injection mitigations — not a claim that prompt injection is solved. Bug reports, security critiques, and suggestions that fit the defense-in-depth model are welcome via GitHub Issues or PRs.

---

## License

MIT License — see [LICENSE](LICENSE).

---

Use at your own risk. Always review external content before exposing it to AI agents.