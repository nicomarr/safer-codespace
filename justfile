# justfile - Command runner for common project tasks
# Run `just --list` to see all available commands

# Display this help message
help:
    @just --list

# Install Python dependencies using uv
install:
    uv pip install -r requirements.txt

# Run all tests
test:
    @just test-connectivity
    @just test-url-to-markdown

# Test network connectivity
test-connectivity:
    bash tests/network/test_connectivity.sh

# Test url_to_markdown tool
test-url-to-markdown:
    uv run tests/network/test_url_to_markdown.py

# Start a local development server on specified port (default: 8000)
serve port="8000":
    python -m http.server {{port}}

# Clean up temporary files and caches
clean:
    find . -type d -name "__pycache__" -exec rm -rf {} +
    find . -type f -name "*.pyc" -delete
    find . -type d -name ".pytest_cache" -exec rm -rf {} +

# View the development guide in the terminal
docs:
    glow CLAUDE.md

# Run git status
status:
    git status

# Create a new git branch and switch to it
new-branch name:
    git switch -c {{name}}
