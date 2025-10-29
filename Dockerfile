FROM ubuntu:24.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install essential development tools and dependencies
RUN apt-get update && apt-get install -y \
    # Basic utilities
    curl \
    wget \
    git \
    vim \
    nano \
    tmux \
    zsh \
    sudo \
    # Build essentials
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    # Python and pip
    python3 \
    python3-pip \
    python3-dev \
    # Additional useful tools
    jq \
    just \
    unzip \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 22.x LTS (latest LTS version)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI (Anthropic's Claude CLI)
RUN npm install -g @anthropic-ai/claude-code
# RUN claude migrate-installer

# Install OpenAI Codex CLI
RUN npm install -g @openai/codex

# Install oh-my-zsh for root user
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Copy preconfigured .zshrc into place
COPY vol/root/.zshrc /root/.zshrc

# Add local bin to PATH for root
ENV PATH="/root/.local/bin:${PATH}"

# Set up workspace location
RUN mkdir -p /workdir
WORKDIR /workdir

# Set hostname environment variable
ENV HOSTNAME=yolo-os

# Default command keeps the container running for devcontainer CLI
CMD ["/bin/sh", "-c", "sleep infinity"]
