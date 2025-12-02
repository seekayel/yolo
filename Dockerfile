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
    # Pyenv dependencies
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
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

# Install Warp CLI (warp-cli) from the official Warp APT repository
RUN wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor > /tmp/warpdotdev.gpg \
    && install -D -o root -g root -m 644 /tmp/warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg \
    && rm /tmp/warpdotdev.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list \
    && apt-get update \
    && apt-get install -y warp-cli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=onceler
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ARG USER_HOME=/home/${USERNAME}
ARG PYTHON_VERSION=3.13.6

# Create non-root developer user with passwordless sudo and workspace ownership
RUN if getent group ${USER_GID} >/dev/null; then \
        groupadd ${USERNAME}; \
    else \
        groupadd --gid ${USER_GID} ${USERNAME}; \
    fi \
    && if getent passwd ${USER_UID} >/dev/null; then \
        useradd -m -s /bin/zsh -g ${USERNAME} ${USERNAME}; \
    else \
        useradd --uid ${USER_UID} -m -s /bin/zsh -g ${USERNAME} ${USERNAME}; \
    fi \
    && mkdir -p /workdir \
    && chown ${USERNAME}:${USERNAME} /workdir \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# Switch to the non-root user for all remaining setup
USER ${USERNAME}
ENV HOME=${USER_HOME}
ENV PYENV_ROOT="${HOME}/.pyenv"
ENV NPM_CONFIG_PREFIX="${HOME}/.npm-global"
ENV PATH="${HOME}/.local/bin:${NPM_CONFIG_PREFIX}/bin:${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"

# Use the home directory while configuring the shell and runtimes
WORKDIR ${HOME}

# Install oh-my-zsh for the onceler user
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install pyenv and desired Python version for the onceler user
RUN curl https://pyenv.run | bash
RUN pyenv install ${PYTHON_VERSION} && \
    pyenv global ${PYTHON_VERSION}
RUN ${PYENV_ROOT}/versions/${PYTHON_VERSION}/bin/pip install --upgrade pip && \
    ${PYENV_ROOT}/versions/${PYTHON_VERSION}/bin/pip install uv && \
    pyenv rehash

# Install Node-based AI CLIs inside the user's npm prefix
RUN mkdir -p "${NPM_CONFIG_PREFIX}" && \
    npm install -g @anthropic-ai/claude-code @openai/codex

# Copy the preconfigured zshrc for the onceler user
COPY --chown=${USERNAME}:${USERNAME} vol/root/.zshrc ${HOME}/.zshrc

# Set up workspace location owned by the onceler user
WORKDIR /workdir

# Set hostname environment variable
ENV HOSTNAME=yolo-os

# Default command keeps the container running for devcontainer CLI
CMD ["/bin/sh", "-c", "sleep infinity"]
