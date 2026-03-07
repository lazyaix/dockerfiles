# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repo contains Dockerfiles for the **lazyaix** development environment, managed via CMake. It builds Docker images with C/C++ toolchains, CMake, Neovim (with lazy.nvim plugins from ohmycmake/dotfiles), and supporting tools.

## Architecture

```
├── CMakeLists.txt              # Root: project options + include(DockerImage)
├── cmake/
│   └── DockerImage.cmake       # Reusable add_docker_image() function
├── images/
│   ├── CMakeLists.txt          # Aggregator + build-all target
│   ├── base/
│   │   ├── CMakeLists.txt
│   │   └── base.dockerfile     # Base: ubuntu + toolchain + cmake
│   └── lazyaix/
│       ├── CMakeLists.txt
│       └── lazyaix.dockerfile  # FROM base: neovim + node + dotfiles
├── .github/workflows/
│   ├── ci.yml                  # PR: hadolint + build + smoke test
│   └── publish.yml             # main push: buildx multi-arch + GHCR
```

- **cmake/DockerImage.cmake** — `add_docker_image()` function using `cmake_parse_arguments`. Creates `build-<name>` and `push-<name>` targets, wires dependencies, and exports `DOCKER_IMAGE_<NAME>_TAG` cache variables.
- **images/base/** — Ubuntu noble + build-essential, clang, cmake (kitware), python3, etc. No user created.
- **images/lazyaix/** — `FROM base`: neovim (multi-arch), node.js, ripgrep, fd-find, lazyaix user, dotfiles, pre-installed nvim plugins.

## Build Commands

```bash
# Configure (CMake 4.1+ required, no compiler needed — LANGUAGES NONE)
cmake -B build

# Build individual images
cmake --build build --target build-base
cmake --build build --target build-lazyaix

# Build all images
cmake --build build --target build-all

# Build with custom registry
cmake -B build -DDOCKER_REGISTRY=ghcr.io/lazyaix

# Build directly without CMake
docker build -f images/base/base.dockerfile -t base:latest images/base/
docker build -f images/lazyaix/lazyaix.dockerfile --build-arg BASE_IMAGE=base:latest -t lazyaix:latest images/lazyaix/
```

## Adding a New Image

1. Create `images/<name>/` with `<name>.dockerfile` and `CMakeLists.txt`
2. In the new `CMakeLists.txt`, call `add_docker_image(NAME <name> ...)` with appropriate `DEPENDS` / `BUILD_ARGS`
3. Add `add_subdirectory(<name>)` in `images/CMakeLists.txt` and add `build-<name>` to the `build-all` DEPENDS list
4. Add build/push jobs to `.github/workflows/publish.yml`

## Conventions

- Dockerfiles use the naming pattern `<name>.dockerfile` (not `Dockerfile.<name>`).
- CMake targets follow the pattern `build-<name>` / `push-<name>`.
- The container user is `lazyaix` (non-root, with passwordless sudo) — created in leaf images, not base.
