add_docker_image(
    NAME       lazyaix
    DOCKERFILE "${CMAKE_CURRENT_SOURCE_DIR}/lazyaix.dockerfile"
    CONTEXT    "${CMAKE_CURRENT_SOURCE_DIR}"
    DEPENDS    base
    BUILD_ARGS "BASE_IMAGE=${DOCKER_IMAGE_BASE_TAG}"
)
