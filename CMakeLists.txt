cmake_minimum_required(VERSION 4.1 FATAL_ERROR)

project(dockerfiles
    VERSION         1.0.0
    DESCRIPTION     "Lazyaix docker development environment configurations"
    HOMEPAGE_URL    "https://ohmycmake.com/"
    LANGUAGES       NONE
)

# Docker registry prefix (set to "" for local-only builds)
set(DOCKER_REGISTRY "" CACHE STRING "Docker registry prefix (e.g. ghcr.io/lazyaix)")

# Make DockerImage module available
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(DockerImage)

add_subdirectory(images)
