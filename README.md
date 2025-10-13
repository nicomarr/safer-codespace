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

### AI Development Tools
- **Claude Code** - Anthropic's official CLI for Claude (installed globally via npm)
- **llm** - Command-line tool for interacting with Large Language Models
- **llm-github-models** - Plugin for accessing GitHub's model marketplace
- **GitHub GPT-4o** - Pre-configured as the default model for `llm`

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

# List available models
llm models list

# Switch default model
llm models default <model-name>

# Chat interactively
llm chat
```

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