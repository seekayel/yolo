# YOLO

## Description

YOLO is a containerized development environment that provides a pre-configured Ubuntu workspace with AI coding assistants ready to use. It bundles Claude Code and OpenAI Codex in a Docker container, allowing you to run guns blazing.

The container mounts your current working directory and persists your AI CLI configurations between sessions, making it easy YOLO without feeling dirty about it. A disposable, fully-equipped development environment.

## Install

First, build the Docker image:

```bash
just build
```

Or if you don't have `just` installed:

```bash
docker build -t yolo-os .
```

### Usage

Navigate to any project directory and run:

```bash
yolo
```

This launches an interactive shell inside the container with your current directory mounted at `~/workdir`. Inside the container, you can use the AI CLIs:

```bash
# Inside the YOLO container

# Aliased with --dangerously-skip-permissions
claude

# Aliased with --dangerously-bypass-approvals-and-sandbox
codex
```

Your Claude and Codex configurations (stored in `~/.claude` and `~/.codex` on your host) are automatically mounted and persisted between sessions.

## Building

To develop or modify YOLO:

1. **Edit the Dockerfile** to add or remove tools, change configurations, or update dependencies
2. **Rebuild the image** after making changes:
   ```bash
   just build
   ```
3. **Test your changes** by running the updated container:
   ```bash
   ./yolo
   ```

The main components are:
- **Dockerfile**: Defines the container image with Ubuntu 24.04, development tools, Node.js, Claude CLI, and Codex CLI
- **yolo**: Bash script that launches the container with appropriate volume mounts and settings
- **Justfile**: Build automation (currently just wraps `docker build`)

The container runs as user `onceler` with sudo privileges and includes a customized zsh shell with oh-my-zsh and git integration.

