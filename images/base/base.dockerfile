FROM ubuntu:noble

LABEL org.opencontainers.image.source="https://github.com/lazyaix/dockerfiles"
LABEL org.opencontainers.image.description="Base development image with C/C++ toolchain and CMake"

ENV TERM=xterm-256color
ENV DEBIAN_FRONTEND=noninteractive

# System utilities + build toolchain
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo \
    curl \
    wget \
    git \
    unzip \
    zip \
    ca-certificates \
    gnupg \
    lsb-release \
    build-essential \
    gcc \
    g++ \
    clang \
    gdb \
    make \
    ninja-build \
    ccache \
    pkg-config \
    elfutils \
    autoconf \
    automake \
    libtool \
    python3 \
    python3-venv \
    python3-pip \
    python3-dev \
    vim \
    htop \
    tree \
    less \
    file \
    bash-completion \
    strace \
    ripgrep \
    fd-find \
    jq \
    tmux && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends gh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install CMake from Kitware official repository
RUN wget -O /tmp/kitware-archive.sh https://apt.kitware.com/kitware-archive.sh && \
    bash /tmp/kitware-archive.sh && \
    rm /tmp/kitware-archive.sh && \
    apt-get update && \
    apt-get install -y --no-install-recommends cmake cmake-curses-gui && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
