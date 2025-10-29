# YOLO

## Description

YOLO is a containerized development environment that provides a pre-configured Ubuntu workspace with AI coding assistants ready to use. It bundles Claude Code and OpenAI Codex inside a Dev Container, allowing you to run guns blazing with the Dev Containers CLI.

The container mounts your current working directory and persists your AI CLI configurations between sessions, making it easy YOLO without feeling dirty about it. A disposable, fully-equipped development environment.

## Install

### Prerequisites

- Docker (the Dev Containers CLI uses your local Docker daemon)
- [Dev Containers CLI](https://github.com/devcontainers/cli) (`npm install -g @devcontainers/cli`) or Node.js 18+ so that `npx` can download it on demand

First, build the devcontainer image:

```bash
just build
```

`just build` shells out to the Dev Containers CLI. You can also run the CLI directly if you prefer:

```bash
npx --yes @devcontainers/cli build --workspace-folder .
```

### Usage

Navigate to any project directory and run:

```bash
yolo
```

This launches an interactive shell inside the Dev Container with your current directory mounted at `/workdir`. Inside the container, you can use the AI CLIs:

```bash
# Inside the YOLO container

# Aliased with --dangerously-skip-permissions
claude

# Aliased with --dangerously-bypass-approvals-and-sandbox
codex
```

Your Claude and Codex configurations (stored in `~/.claude` and `~/.codex` on your host) are automatically mounted and persisted between sessions. To keep the container running after you exit, set `YOLO_PERSIST_CONTAINER=1` before invoking `yolo`.

## Building

To develop or modify YOLO:

1. **Edit the Dockerfile** (or `.devcontainer/devcontainer.json`) to add or remove tools, change configurations, or update dependencies
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
- **.devcontainer/devcontainer.json**: Describes how the Dev Containers CLI should build and run the environment, including workspace mounts and host integrations
- **yolo**: Bash script that launches the Dev Container using the Dev Containers CLI
- **Justfile**: Build automation (wraps `devcontainer build`)

The container runs as `root` with a customized oh-my-zsh shell, git integration, and the AI CLI aliases preloaded.
security find-generic-password -s "Claude Code-credentials" -w > "$HOME/.claude/credentials.json"

docker build -t repo-credentials -f - . <<EOF
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
RUN apt-get update && apt-get install -y nodejs npm
RUN npm install -g @anthropic-ai/claude-code
EOF

docker run -it --rm --name repo-credentials -v "$HOME/.claude:/root/.claude" repo-credentials

cat /root/.claude/credentials.json

claude