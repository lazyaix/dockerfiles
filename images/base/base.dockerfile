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
    locales \
    build-essential \
    gcc \
    g++ \
    golang-go \
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
    openssh-client \
    openssh-server \
    strace \
    rpm \
    ripgrep \
    fd-find \
    jq \
    libevent-dev \
    libncurses-dev \
    bison && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure sshd
RUN mkdir -p /run/sshd && \
    ssh-keygen -A

# Generate UTF-8 locale (required for Nerd Font symbols in terminal)
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Build tmux from source (latest release)
ARG TMUX_VERSION=3.6a
RUN curl -fsSL "https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz" \
    -o /tmp/tmux.tar.gz && \
    tar -xzf /tmp/tmux.tar.gz -C /tmp && \
    cd /tmp/tmux-${TMUX_VERSION} && \
    ./configure --prefix=/usr/local && \
    make -j"$(nproc)" && \
    make install && \
    rm -rf /tmp/tmux*

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
