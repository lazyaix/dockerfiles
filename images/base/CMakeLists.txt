add_docker_image(
    NAME       base
    DOCKERFILE "${CMAKE_CURRENT_SOURCE_DIR}/base.dockerfile"
    CONTEXT    "${CMAKE_CURRENT_SOURCE_DIR}"
)
