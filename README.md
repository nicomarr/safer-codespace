# Claude Codespace

A template repository to launch a new GitHub Codespaces instance with AI development tools pre-configured and ready to use.

## What's Preinstalled

This devcontainer comes with the following tools automatically installed:

### Python Environment
- **Python 3.13** (latest stable)
- **uv** - Fast Python package manager
- **pip** - Python package installer

### Node.js Environment
- **Node.js** (latest LTS)
- **npm** (latest)

### Go Environment
- **Go** (latest stable)

### AI Development Tools
- **Claude Code** - Anthropic's official CLI for Claude (installed globally via npm)
- **llm** - Command-line tool for interacting with Large Language Models
- **llm-github-models** - Plugin for accessing GitHub's model marketplace
- **GitHub GPT-4o** - Pre-configured as the default model for `llm`

### Documentation Tools
- **glow** - Render markdown in the terminal with style

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