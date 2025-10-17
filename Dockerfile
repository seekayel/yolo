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

# Install OpenAI Codex CLI
RUN npm install -g @openai/codex

# Create onceler user with sudo privileges
RUN useradd -m -s /bin/zsh onceler && \
    echo "onceler ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to onceler user
USER onceler
WORKDIR /home/onceler

# Install oh-my-zsh for onceler user
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Configure .zshrc with oh-my-zsh, git prompt, and aliases
RUN echo '# Path to oh-my-zsh installation' > /home/onceler/.zshrc && \
    echo 'export ZSH="$HOME/.oh-my-zsh"' >> /home/onceler/.zshrc && \
    echo '' >> /home/onceler/.zshrc && \
    echo '# Enable git plugin' >> /home/onceler/.zshrc && \
    echo 'plugins=(git)' >> /home/onceler/.zshrc && \
    echo '' >> /home/onceler/.zshrc && \
    echo '# Source oh-my-zsh' >> /home/onceler/.zshrc && \
    echo 'source $ZSH/oh-my-zsh.sh' >> /home/onceler/.zshrc && \
    echo '' >> /home/onceler/.zshrc && \
    echo '# Custom prompt with user@host and git info' >> /home/onceler/.zshrc && \
    echo 'autoload -Uz vcs_info' >> /home/onceler/.zshrc && \
    echo 'precmd() { vcs_info }' >> /home/onceler/.zshrc && \
    echo 'zstyle ":vcs_info:git:*" formats " (%b%u%c)"' >> /home/onceler/.zshrc && \
    echo 'zstyle ":vcs_info:*" enable git' >> /home/onceler/.zshrc && \
    echo 'zstyle ":vcs_info:*" check-for-changes true' >> /home/onceler/.zshrc && \
    echo 'zstyle ":vcs_info:*" unstagedstr "*"' >> /home/onceler/.zshrc && \
    echo 'zstyle ":vcs_info:*" stagedstr "+"' >> /home/onceler/.zshrc && \
    echo 'setopt prompt_subst' >> /home/onceler/.zshrc && \
    echo 'PROMPT="%F{green}%n@%m%f:%F{blue}%~%f%F{yellow}\${vcs_info_msg_0_}%f$ "' >> /home/onceler/.zshrc && \
    echo '' >> /home/onceler/.zshrc && \
    echo '# Aliases' >> /home/onceler/.zshrc && \
    echo 'alias claude="claude --dangerously-skip-permissions"' >> /home/onceler/.zshrc && \
    echo 'alias codex="codex --dangerously-bypass-approvals-and-sandbox"' >> /home/onceler/.zshrc

# # Create directories for Claude and Codex configurations
# RUN mkdir -p /home/onceler/.claude && \
#     mkdir -p /home/onceler/.codex

# Add local bin to PATH
ENV PATH="/home/onceler/.local/bin:${PATH}"

# Set working directory
WORKDIR /home/onceler

# Set hostname environment variable
ENV HOSTNAME=yolo-os

# Default command that sets hostname and starts zsh
CMD sudo hostname yolo-os 2>/dev/null || true; /bin/zsh

