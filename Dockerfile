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

# Install oh-my-zsh for better shell experience
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true

# Create onceler user with sudo privileges
RUN useradd -m -s /bin/zsh onceler && \
    echo "onceler ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to onceler user
USER onceler
WORKDIR /home/onceler

# # Create directories for Claude and Codex configurations
# RUN mkdir -p /home/onceler/.claude && \
#     mkdir -p /home/onceler/.codex

# Add local bin to PATH
ENV PATH="/home/onceler/.local/bin:${PATH}"

# Set working directory
WORKDIR /home/onceler

# Default command
CMD ["/bin/zsh"]

