# Claude Codespace

A template repository to launch a new GitHub Codespaces instance with AI development tools pre-configured and ready to use.

## Security Features

### Network Firewall (Default: Enabled)

This devcontainer includes an **automatic network firewall** that restricts outbound connections to only approved development endpoints. This provides defense-in-depth security for your development environment.

**What's Protected:**
- Blocks all outbound traffic by default
- Only allows connections to pre-approved domains required for development
- Prevents unauthorized data exfiltration
- Validates firewall rules automatically on startup

**Approved Endpoints:**
- GitHub (web, API, git operations)
- npm registry
- PyPI and Python package hosting
- Anthropic API
- Azure GitHub Models API
- Google Gemini API
- Go modules (proxy.golang.org, sum.golang.org)
- VS Code marketplace and updates

**Testing the Firewall:**
```bash
# Run comprehensive connectivity test
bash tests/network/test_connectivity.sh

# This will verify:
# - All required development endpoints are accessible
# - Unauthorized domains (example.com) are blocked
```

**Adding Domains to the Allowlist:**

To add new domains to the firewall allowlist, edit `.devcontainer/init-firewall.sh`:

1. Locate the domain resolution loop (around line 67):
   ```bash
   for domain in \
       "registry.npmjs.org" \
       "api.anthropic.com" \
       # ... existing domains ...
   ```

2. Add your domain to the list:
   ```bash
   for domain in \
       "registry.npmjs.org" \
       "api.anthropic.com" \
       "your-new-domain.com" \
       # ... rest of domains ...
   ```

3. Rebuild the devcontainer or manually run:
   ```bash
   sudo /workspaces/claude-codespace/.devcontainer/init-firewall.sh
   ```

**Important Notes:**
- The firewall uses DNS resolution, so domain IPs are resolved at container startup
- CDNs and services with dynamic IPs are supported through DNS updates
- GitHub IP ranges are fetched from GitHub's API and aggregated automatically
- The firewall preserves Docker's internal DNS resolution (127.0.0.11)

## What's Preinstalled

This devcontainer comes with the following tools automatically installed:

### Python Environment
- **Python 3.13** (latest stable)
- **uv** - Fast Python package manager
- **pip** - Python package installer

### Node.js Environment
- **Node.js 24.x** (pinned for Claude Code compatibility - Node.js 25 is currently not supported)
- **npm** (latest)

### Go Environment
- **Go** (latest stable)

### AI Development Tools
- **Claude Code** - Anthropic's official CLI for Claude (installed globally via npm)
- **llm** - Command-line tool for interacting with Large Language Models
- **llm-github-models** - Plugin for accessing GitHub's model marketplace
- **llm-anthropic** - Plugin for accessing Anthropic's Claude models
- **llm-gemini** - Plugin for accessing Google's Gemini models
- **GitHub GPT-4o** - Pre-configured as the default model for `llm`

### Documentation Tools
- **glow** - Render markdown in the terminal with style

### Task Automation
- **just** - Command runner for project-specific tasks (similar to make, but simpler)

## Getting Started

### Using Claude Code
Claude Code is Anthropic's interactive CLI tool for AI-assisted development:

```bash
# Start Claude Code in the current directory
claude

# Start with a specific prompt
claude "help me refactor this code"

# View help and options
claude --help
```

### Using llm CLI
The `llm` tool provides command-line access to various language models:

```bash
# Use the default model (GitHub GPT-4o)
llm "explain this code" < script.py

# Alternative: pipe file contents using cat
cat script.py | llm "explain this code"

# Pipe any command output to llm
echo "Hello world" | llm "translate to Spanish"

# List available models
llm models list

# Switch default model
llm models default <model-name>

# Chat interactively
llm chat

# Get comprehensive help and see all available commands
llm --help

# Get help for specific subcommands
llm models --help
llm chat --help
```

#### Available llm Commands
Run `llm --help` to see all commands. Key commands include:

- `llm prompt` - Execute a prompt (default command)
- `llm chat` - Hold an ongoing chat with a model
- `llm models` - Manage available models
- `llm keys` - Manage stored API keys for different models
- `llm logs` - Tools for exploring logged prompts and responses
- `llm templates` - Manage stored prompt templates
- `llm aliases` - Manage model aliases
- `llm plugins` - List installed plugins
- `llm install` - Install packages from PyPI into the LLM environment
- `llm embed` - Embed text and store or return the result
- `llm collections` - View and manage collections of embeddings
- `llm similar` - Return top N similar IDs from a collection

For detailed documentation, visit: https://llm.datasette.io/

### Python Development
```bash
# Install packages with uv (faster)
uv pip install package-name

# Or use traditional pip
pip install package-name

# Run Python scripts
python script.py

# Start Python REPL
python
```

### Node.js Development
```bash
# Install packages
npm install package-name

# Run scripts defined in package.json
npm run script-name

# Start Node REPL
node
```

### Go Development
```bash
# Initialize a new Go module
go mod init module-name

# Install Go packages
go get package-name

# Run Go programs
go run main.go

# Build Go programs
go build

# Install Go tools
go install package-name@latest
```

### Using glow (Markdown Viewer)
```bash
# View a markdown file with style in the terminal
glow README.md

# View the CLAUDE.md development guide
glow CLAUDE.md

# Browse all markdown files in current directory
glow

# Pipe markdown content to glow
cat file.md | glow -
```

### Using just (Command Runner)
`just` is a task automation tool that makes it easy to define and run project-specific commands. It uses a `justfile` to store command definitions.

```bash
# List all available commands
just --list

# Run a specific command
just command-name

# Run a command with arguments
just command-name arg1 arg2

# Show what a command would do without running it
just --dry-run command-name

# View a specific command definition
just --show command-name
```

#### Creating Commands in justfile
A `justfile` contains command definitions written with simple syntax:

```just
# Comment describing what this command does
command-name:
    command-to-run
    another-command

# Command with parameters
greet name:
    echo "Hello, {{name}}!"

# Command with default parameter
serve port="8000":
    python -m http.server {{port}}
```

For more information, visit: https://just.systems/man/en/

## Development Philosophy

This repository includes a comprehensive development guide in `CLAUDE.md` covering:

- Literate Programming principles
- MVP-first methodology (6-8 step rule)
- Test-Driven Development practices
- Python coding standards and style guide
- Git workflow with Conventional Commits

Read `CLAUDE.md` for detailed guidelines on development practices.

## Using This Template

1. Click "Use this template" to create a new repository
2. Open in GitHub Codespaces
3. Wait for the devcontainer to build (first time only)
4. Start coding with `claude` or your preferred tools

All tools are automatically installed and configured during the container build process.