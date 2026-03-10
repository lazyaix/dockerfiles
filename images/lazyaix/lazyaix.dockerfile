ARG BASE_IMAGE=base:latest
FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.source="https://github.com/lazyaix/dockerfiles"
LABEL org.opencontainers.image.description="Lazyaix dev environment with Neovim, Node.js, and dotfiles"

# Install Neovim from GitHub releases (auto-detect architecture)
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ]; then NVIM_ARCH="arm64"; else NVIM_ARCH="x86_64"; fi && \
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz && \
    rm -rf /opt/nvim-linux-${NVIM_ARCH} && \
    tar -C /opt -xzf nvim-linux-${NVIM_ARCH}.tar.gz && \
    rm nvim-linux-${NVIM_ARCH}.tar.gz && \
    ln -sf /opt/nvim-linux-${NVIM_ARCH}/bin/nvim /usr/local/bin/nvim

# Create lazyaix user
RUN useradd -m -s /bin/bash lazyaix && \
    echo "lazyaix ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER lazyaix
WORKDIR /home/lazyaix

# Install nvm + Node.js 24
ENV NVM_DIR="/home/lazyaix/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install 24
ENV PATH="$NVM_DIR/versions/node/v24.14.0/bin:$PATH"

# Clone dotfiles and symlink configs
RUN git clone https://github.com/lazyaix/dotfiles.git ~/.config/dotfiles && \
    ln -s ~/.config/dotfiles/nvim ~/.config/nvim && \
    ln -s ~/.config/dotfiles/tmux ~/.config/tmux

# Pre-install nvim plugins (lazy.nvim bootstrap + plugin sync + build steps)
RUN nvim --headless "+Lazy! sync" +qa 2>&1 || true
# Compile treesitter parsers (ensure_installed + community packs: lua/python/rust/go/cpp)
RUN nvim --headless \
    "+TSInstallSync lua vim vimdoc bash json jsonc yaml toml markdown markdown_inline regex c cpp python rust go" \
    +qa 2>&1 || true

# Install Claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash

# Install Gemini CLI and Codex CLI
RUN npm install -g @google/gemini-cli @openai/codex

CMD ["/bin/bash"]
