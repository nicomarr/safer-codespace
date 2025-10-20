# Safer Codespace

![Experimental](https://img.shields.io/badge/status-experimental-orange)
![Security Focused](https://img.shields.io/badge/security-defense--in--depth-blue)
![License](https://img.shields.io/badge/license-MIT-green)

An **experimental** development environment exploring defense-in-depth approaches to mitigate **prompt injection** risks when using AI coding assistants.

> **⚠️ Security Notice:** This template uses multiple security layers (network firewall, content segregation, human review) to reduce prompt injection risks. While no approach is perfect, these controls make data exfiltration significantly harder. [Learn more about the threat model →](#understanding-the-security-model)

---

## Table of Contents

- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [What's Included](#whats-included)
- [Choosing the Right Tool](#choosing-the-right-tool)
- [Tool Usage Guides](#tool-usage-guides)
- [Understanding the Security Model](#understanding-the-security-model)
- [Additional Resources](#additional-resources)
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
- **[llm](https://llm.datasette.io/)** developed by Simon Willison, A CLI tool for interacting with OpenAI, Anthropic’s Claude, Google’s Gemini, Meta’s Llama and dozens of other Large Language Models
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
- **Network firewall** - Blocks unauthorized outbound connections (auto-configured)
- **Content segregation** - Separate `context/trusted/` and `context/untrusted/` directories
- **No GitHub CLI** - Intentionally excluded to prevent potential data exfiltration

---

## Choosing the Right Tool

**Not every task needs an AI agent.** Choose the right tool for your needs:

### When to use Claude Code

Best for **focused development tasks** where you need file access and iterative assistance:

- **Boilerplate in unfamiliar languages** - You know the goal but not the specific syntax or patterns
- **Test-driven development** - Draft test cases and develop iteratively with Claude's guidance
- **Codebase exploration** - Understand existing code through Claude's search and analysis capabilities
- **Simple features from scratch** - Build UIs or functionality with minimal dependencies
- **Targeted refactoring** - Modify existing code patterns across related files

```bash
# Start interactive session
claude

# Start with a specific task
claude "Give me an overview of this codebase"
```

### When to use the `llm` CLI tool

Perfect for **text processing tasks** that don't need file access or command execution. Particularly useful because you can **pipe output from other CLI tools** directly to it:

- **Explain errors or code snippets** - Paste error messages or functions for quick analysis
- **Generate commit messages** - Create conventional commits from staged changes
- **Quick code reviews** - Analyze diffs for potential issues or improvements
- **Explore Git history** - Analyze commit logs, changes, and project evolution patterns
- **Transform data formats** - Convert between JSON, CSV, markdown, or other text formats
- **Programming Q&A** - Get answers about syntax, concepts, or best practices

```bash
# Generate commit message from staged changes
git diff --staged | llm -s "write a conventional commit message for these changes"

# Quick code review
git diff main | llm "review these changes for potential issues"

# Ask a question
cat script.py | llm "explain what this code does"
```

**Security benefit:** `llm` cannot access your files or run commands out-of-the-box. Even if compromised by prompt injection, damage is limited to the text you explicitly provide.

### When to use VS Code with LLM integration

Perfect for **controlled, inline code editing and completion** when you want to restrict changes to specific files or sections:

- **Targeted code modifications** - Edit specific functions or code blocks without affecting other files
- **Inline documentation** - Generate comments, docstrings, type hints, or explanations within existing code
- **Code completion and suggestions** - Get LLM assistance while maintaining full control over what you write
- **Refactoring specific sections** - Modify code patterns within a single file or selected region
- **Language-specific optimizations** - Improve syntax, or performance in focused code sections

This approach gives you the benefit of LLM assistance while ensuring changes remain scoped to exactly what you want to modify.

### When to skip AI altogether

For **simple, routine tasks**, such as:

- Basic git operations
- Installing packages
- Running tests
- Simple config changes

**Why?** Faster, safer, and you maintain direct control.

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

For detailed documentation: https://docs.claude.com/en/docs/claude-code/overview

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

**Key commands:**
- `llm prompt` - Execute a one-off prompt (default)
- `llm chat` - Start an interactive conversation
- `llm models` - Manage available models
- `llm keys` - Configure API keys for different providers
- `llm logs` - View prompt/response history
- `llm templates` - Manage reusable prompt templates

For detailed documentation: https://llm.datasette.io/

<details>
<summary><strong>Python Development</strong></summary>

```bash
# Install packages (fast method)
uv pip install package-name

# Traditional pip
pip install package-name

# Run scripts
python script.py
```
</details>

<details>
<summary><strong>Node.js Development</strong></summary>

```bash
# Install packages
npm install package-name

# Run package.json scripts
npm run script-name
```
</details>

<details>
<summary><strong>Go Development</strong></summary>

```bash
# Initialize module
go mod init module-name

# Install packages
go get package-name

# Run programs
go run main.go
```
</details>

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

### Our Defense-in-Depth Approach

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
- `llm` (no file access) over Claude Code for simple tasks
- Manual commands over AI for routine operations

### Why No GitHub CLI?

The `gh` CLI is **intentionally excluded** as part of our security-first approach:

- **Risk:** Could be used to exfiltrate data via issues, PRs, or gists
- **Alternative:** Standard `git` commands handle most workflows
- **If needed:** Install manually (`sudo apt install gh`) with full awareness of the risk

### Learn More

For detailed information about prompt injection:
- Read the curated content in `context/trusted/simon-willison-weblog-content/`
- Original 2022 post coining "prompt injection"
- 2025 "lethal trifecta" framework
- Real-world examples of attacks on major AI systems

---

## Additional Resources

### Development Philosophy

This repository includes `CLAUDE.md` with comprehensive guidelines on:
- Literate Programming principles
- MVP-first methodology (6-8 step rule)
- Test-Driven Development practices
- Python coding standards
- Git workflow with Conventional Commits

**View it:** `glow CLAUDE.md`

### Security Resources

- **Prompt Injection Deep Dive:** `context/trusted/simon-willison-weblog-content/`
- **GitHub Actions Risks:** `context/trusted/github-blog-posts/github-actions-workflow-injection-risks.md`

---

## Troubleshooting

### Firewall Issues

**Problem:** Can't connect to a required service

**Solution:** Add the domain to `.devcontainer/init-firewall.sh` and rebuild:
```bash
sudo /workspaces/claude-codespace/.devcontainer/init-firewall.sh
```

### Claude Code Issues

**Problem:** "Claude Code not found"

**Solution:** Node.js 25+ is not supported. This template uses Node.js 24.x. Rebuild the container.

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

This is an **experimental** repository exploring prompt injection mitigations. We welcome:

- **Bug reports** - File an issue describing the problem
- **Security feedback** - Share your perspective on the defense-in-depth approach
- **Tool suggestions** - Propose additions that align with our security model
- **Documentation improvements** - Help make this more accessible

**Note:** We do not claim to have "solved" prompt injection. This template explores practical mitigation strategies using defense-in-depth principles.

### Providing Feedback

1. **GitHub Issues** - For bugs, feature requests, or questions
2. **Pull Requests** - For documentation or tooling improvements
3. **Discussions** - For broader conversations about security approaches

---

## License

MIT License - See LICENSE file for details

---

**Built by the security-conscious developer community. Use at your own risk and always review external content before exposing it to AI agents.**