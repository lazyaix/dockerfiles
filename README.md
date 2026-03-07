# lazyaix/dockerfiles

Development environment Docker images with C/C++ toolchain, CMake, Neovim, and AI coding assistants.

## Quick Start

```bash
docker pull ghcr.io/lazyaix/lazyaix:latest
docker run -it ghcr.io/lazyaix/lazyaix:latest
```

Supported architectures: `linux/amd64`, `linux/arm64`

## Images

| Image | Pull Command | Description |
|-------|-------------|-------------|
| **lazyaix** | `docker pull ghcr.io/lazyaix/lazyaix:latest` | Full dev environment with Neovim, Node.js, Claude Code, Gemini CLI, Codex CLI, and dotfiles |
| **base** | `docker pull ghcr.io/lazyaix/base:latest` | Ubuntu Noble + build-essential, clang, CMake, Python3, GitHub CLI |

## What's Included

### base

- Ubuntu Noble (24.04)
- GCC, G++, Clang, GDB, Make, Ninja, ccache
- CMake (Kitware official repo)
- Python3 + pip + venv
- GitHub CLI, ripgrep, fd-find, jq

### lazyaix

Everything in base, plus:

- Neovim (latest) with lazy.nvim and [ohmycmake/dotfiles](https://github.com/ohmycmake/dotfiles)
- Node.js 24 (via nvm)
- [Claude Code](https://claude.ai/code) - Anthropic's AI coding assistant
- [Gemini CLI](https://github.com/google/gemini-cli) - Google's AI coding assistant
- [Codex CLI](https://github.com/openai/codex) - OpenAI's AI coding agent
- Non-root `lazyaix` user with passwordless sudo

## Build from Source

```bash
# Configure
cmake -B build

# Build all images
cmake --build build --target build-all

# Or build individually
cmake --build build --target build-base
cmake --build build --target build-lazyaix
```

## License

MIT
