add_subdirectory(base)
add_subdirectory(lazyaix)

# Convenience target to build all images
add_custom_target(build-all
    DEPENDS build-base build-lazyaix
    COMMENT "Building all Docker images"
)
