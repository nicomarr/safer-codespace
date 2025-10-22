# SpecStory CLI Installation Quickstart for GitHub Codespaces & Dev Containers

This guide covers installing SpecStory CLI in containerized Linux environments, specifically:
- **GitHub Codespaces**
- **VS Code Dev Containers** (Docker)

For macOS or Windows native installations, refer to the official SpecStory documentation.

## Prerequisites

- Dev Container or Codespace running Linux
- Access to download SpecStory CLI binary

## Determine Which Binary to Download

### Check Your Architecture

Your dev container's architecture depends on the host machine you're running on:

1. **Check the current architecture**:
   ```bash
   uname -m
   ```

2. **Common architectures**:
   - `x86_64` or `amd64` → Download `SpecStoryCLI_Linux_x86_64.tar.gz`
   - `aarch64` or `arm64` → Download `SpecStoryCLI_Linux_arm64.tar.gz`

### Architecture by Platform

- **GitHub Codespaces**: Currently uses `x86_64` (AMD64) architecture
- **Apple Silicon Mac (M1/M2/M3)**: Uses `aarch64` (ARM64) when running Docker locally
- **Intel/AMD Mac or PC**: Uses `x86_64` (AMD64)
- **Linux on ARM (Raspberry Pi, etc.)**: Uses `aarch64` (ARM64)

**Note**: The dev container image (e.g., `mcr.microsoft.com/devcontainers/python:3.13-bullseye`) is built for multiple architectures. Docker automatically pulls the version matching your host machine's architecture.

### Verify Linux Distribution (Optional)

While SpecStory binaries work across Linux distributions, you can check your container's OS:
```bash
cat /etc/os-release
```

This environment uses Debian 11 (bullseye), but the binary works on any modern Linux distribution.

## Installation Steps

### 1. Identify Your Architecture

Check your system architecture:
```bash
uname -m
```

For this environment, we're running on `aarch64` (ARM64).

### 2. Download the Binary

Download the appropriate version from the SpecStory releases:
- For ARM64: `SpecStoryCLI_Linux_arm64.tar.gz`
- For x86_64: `SpecStoryCLI_Linux_x86_64.tar.gz`

**Note**: If you're behind a firewall, download the file on your host machine first, then upload it to the container.

### 3. Upload to Container (if needed)

1. Create a temporary directory in your workspace:
   ```bash
   mkdir -p ~/temp
   cd ~/temp
   ```

2. Drag and drop the downloaded `.tar.gz` file into VS Code Explorer, or right-click a folder and select "Upload..."

### 4. Extract the Archive

Navigate to where you uploaded the file and extract (replace with your architecture):
```bash
cd ~/temp
tar -xzf SpecStoryCLI_Linux_arm64.tar.gz
```

This will extract the `specstory` binary.

### 5. Install to Workspace Location

**Important**: In containerized environments, don't install to `/usr/local/bin/` as it will be lost when the container rebuilds. Instead, install to your persisted workspace.

Navigate to your workspace root directory first:
```bash
# For GitHub Codespaces, this is usually /workspaces/<repo-name>
# For local Dev Containers, it depends on your mount configuration
cd /workspaces/*  # Or navigate to your specific workspace directory
```

Then install the binary:
```bash
# Create directory and install (run from your workspace root)
mkdir -p .specstory/bin
mv ~/temp/specstory .specstory/bin/
chmod +x .specstory/bin/specstory
```

### 6. Add to PATH

Add the binary location to your PATH. The key is to use the full absolute path to your workspace.

**Method 1 - Find your workspace path first:**
```bash
# Get your current workspace directory
pwd
# Copy the output, it should be something like /workspaces/your-repo-name
```

Then add to `.bashrc` using that exact path:
```bash
echo 'export PATH="/workspaces/your-repo-name/.specstory/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Method 2 - Automated (if you're already in your workspace root):**
```bash
echo "export PATH=\"$(pwd)/.specstory/bin:\$PATH\"" >> ~/.bashrc
source ~/.bashrc
```

**Important**: Make sure you're in your workspace directory (e.g., `/workspaces/your-repo-name/`) when running Method 2, NOT in `/workspaces/` or `~/temp/`.

### 7. Verify Installation

Check that SpecStory is installed correctly:
```bash
specstory --version
```

You should see output like: `0.11.0 (SpecStory)`

### 8. Test SpecStory

**Important**: Always run SpecStory from within your workspace directory, not from `/workspaces/`:

```bash
# Navigate to your workspace first
cd /workspaces/your-repo-name

# Test with help command
specstory --help

# Run SpecStory with Claude Code
specstory run claude
```

If you get a "permission denied" error about creating `.specstory` directory, make sure you're in your workspace directory (`/workspaces/your-repo-name/`), not the parent `/workspaces/` directory.

## Why This Approach?

### Container Considerations

- **Persistence**: `/workspaces` is mounted from the host and persists across container rebuilds
- **Permissions**: Installing to `/usr/local/bin/` requires sudo and is ephemeral in containers
- **Data Storage**: SpecStory will create `.specstory` directory for conversation history, which will be preserved in the workspace

### Directory Structure

```
/workspaces/YOUR-REPO-NAME/      # Your workspace root
├── .specstory/
│   ├── bin/
│   │   └── specstory            # Binary location
│   └── ...                       # SpecStory data (created automatically)
└── (your project files)
```

The `~/temp` directory can be deleted after installation.

## Cleanup (Optional)

After successful installation, you can remove the temporary directory and archive:
```bash
rm -rf ~/temp
```

## Advanced: Automating Installation in Dev Containers

To avoid manual installation every time you rebuild your container, you can automate SpecStory installation in your `.devcontainer/devcontainer.json`:

### Option 1: Add to postCreateCommand

```json
{
  "postCreateCommand": "curl -L https://github.com/specstory/releases/download/vX.X.X/SpecStoryCLI_Linux_x86_64.tar.gz -o /tmp/specstory.tar.gz && tar -xzf /tmp/specstory.tar.gz -C /tmp && mkdir -p ${containerWorkspaceFolder}/.specstory/bin && mv /tmp/specstory ${containerWorkspaceFolder}/.specstory/bin/ && chmod +x ${containerWorkspaceFolder}/.specstory/bin/specstory && echo 'export PATH=\"${containerWorkspaceFolder}/.specstory/bin:$PATH\"' >> ~/.bashrc"
}
```

### Option 2: Create Installation Script

1. Create `.devcontainer/install-specstory.sh`:
   ```bash
   #!/bin/bash
   set -e
   
   ARCH=$(uname -m)
   if [ "$ARCH" = "x86_64" ]; then
       BINARY_URL="https://github.com/specstory/releases/download/vX.X.X/SpecStoryCLI_Linux_x86_64.tar.gz"
   elif [ "$ARCH" = "aarch64" ]; then
       BINARY_URL="https://github.com/specstory/releases/download/vX.X.X/SpecStoryCLI_Linux_arm64.tar.gz"
   else
       echo "Unsupported architecture: $ARCH"
       exit 1
   fi
   
   echo "Installing SpecStory for $ARCH..."
   curl -L "$BINARY_URL" -o /tmp/specstory.tar.gz
   tar -xzf /tmp/specstory.tar.gz -C /tmp
   mkdir -p "${WORKSPACE_DIR}/.specstory/bin"
   mv /tmp/specstory "${WORKSPACE_DIR}/.specstory/bin/"
   chmod +x "${WORKSPACE_DIR}/.specstory/bin/specstory"
   rm /tmp/specstory.tar.gz
   
   # Add to PATH if not already there
   if ! grep -q ".specstory/bin" ~/.bashrc; then
       echo "export PATH=\"${WORKSPACE_DIR}/.specstory/bin:\$PATH\"" >> ~/.bashrc
   fi
   
   echo "SpecStory installed successfully!"
   ```

2. Update `.devcontainer/devcontainer.json`:
   ```json
   {
     "postCreateCommand": "WORKSPACE_DIR=${containerWorkspaceFolder} bash ${containerWorkspaceFolder}/.devcontainer/install-specstory.sh"
   }
   ```

**Note**: Replace `vX.X.X` with the actual version number and update the URL to the correct SpecStory releases URL.

## Differences from Standard Linux Installation

The standard Linux installation (shown in the screenshot) uses:
- `sudo mv specstory /usr/local/bin/` - System-wide installation
- `chmod +x /usr/local/bin/specstory` - Make executable in system directory

In containerized environments, we instead:
- Install to workspace directory for persistence
- Add to user's PATH via `.bashrc`
- Avoid sudo requirements where possible

## Next Steps

Run `specstory --help` to see available commands and start using SpecStory to auto-save your Claude Code Terminal Agent conversations to searchable markdown!

## Troubleshooting

### Permission Denied Error

**Error**: `Error creating history directory: mkdir /workspaces/.specstory: permission denied`

**Solution**: Make sure you're running SpecStory from within your workspace directory:
```bash
cd /workspaces/your-repo-name  # Replace with your actual repo name
specstory run claude
```

SpecStory creates its data directory in your current working directory, so you must be in a directory where you have write permissions.

### Binary Not Found After Installation

**Error**: `specstory: command not found`

**Solution**: 
1. Check if PATH was added to `.bashrc`:
   ```bash
   grep specstory ~/.bashrc
   ```
   
2. If it's there, reload your shell:
   ```bash
   source ~/.bashrc
   ```
   
3. Or open a new terminal window

4. Verify the binary exists:
   ```bash
   ls -la /workspaces/your-repo-name/.specstory/bin/specstory
   ```

### Installation Lost After Container Rebuild

**Issue**: SpecStory needs to be reinstalled after rebuilding the container.

**Solution**: The `.specstory` directory should persist in your workspace. If it doesn't:
- Make sure you installed to `/workspaces/your-repo-name/.specstory/bin/`, not to `/usr/local/bin/`
- Check that your `.bashrc` modification persists (you may need to add it to a dotfiles repository or devcontainer configuration)
- Consider adding the installation to your `postCreateCommand` in `.devcontainer/devcontainer.json` for automatic setup

### Checking Installation Location

To verify where SpecStory is installed:
```bash
which specstory
# Should output: /workspaces/your-repo-name/.specstory/bin/specstory

ls -la $(which specstory)
# Should show: -rwxr-xr-x ... specstory
```
