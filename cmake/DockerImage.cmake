#[=======================================================================[.rst:
DockerImage
-----------

Provides ``add_docker_image()`` — a reusable function that creates CMake
custom targets for building and pushing Docker images.

Usage::

    add_docker_image(
        NAME        <name>
        DOCKERFILE  <path>            # default: ${name}.dockerfile
        CONTEXT     <dir>             # default: CMAKE_CURRENT_SOURCE_DIR
        TAG         <tag>             # default: PROJECT_VERSION
        DEPENDS     <image1> ...      # parent images (adds target deps)
        BUILD_ARGS  <KEY=VALUE> ...   # docker --build-arg flags
    )

Creates targets:
  - ``build-<name>``  — ``docker build``
  - ``push-<name>``   — ``docker push``

Sets cache variable ``DOCKER_IMAGE_<NAME>_TAG`` so downstream images can
reference the full image:tag as a build arg.
#]=======================================================================]

function(add_docker_image)
    set(options "")
    set(oneValueArgs NAME DOCKERFILE CONTEXT TAG)
    set(multiValueArgs DEPENDS BUILD_ARGS)

    cmake_parse_arguments(DI "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # --- defaults -----------------------------------------------------------
    if(NOT DI_NAME)
        message(FATAL_ERROR "add_docker_image: NAME is required")
    endif()

    if(NOT DI_DOCKERFILE)
        set(DI_DOCKERFILE "${CMAKE_CURRENT_SOURCE_DIR}/${DI_NAME}.dockerfile")
    endif()

    if(NOT DI_CONTEXT)
        set(DI_CONTEXT "${CMAKE_CURRENT_SOURCE_DIR}")
    endif()

    if(NOT DI_TAG)
        set(DI_TAG "${PROJECT_VERSION}")
    endif()

    # --- full image reference -----------------------------------------------
    if(DOCKER_REGISTRY)
        set(_full_image "${DOCKER_REGISTRY}/${DI_NAME}:${DI_TAG}")
    else()
        set(_full_image "${DI_NAME}:${DI_TAG}")
    endif()

    # Export for downstream images
    string(TOUPPER "${DI_NAME}" _upper_name)
    set(DOCKER_IMAGE_${_upper_name}_TAG "${_full_image}"
        CACHE INTERNAL "Full image:tag for ${DI_NAME}")

    # --- build-arg list -----------------------------------------------------
    set(_build_args "")
    foreach(_arg IN LISTS DI_BUILD_ARGS)
        list(APPEND _build_args --build-arg "${_arg}")
    endforeach()

    # --- build target -------------------------------------------------------
    add_custom_target(build-${DI_NAME}
        COMMAND docker build
            -f "${DI_DOCKERFILE}"
            -t "${_full_image}"
            ${_build_args}
            "${DI_CONTEXT}"
        WORKING_DIRECTORY "${DI_CONTEXT}"
        COMMENT "Building Docker image ${_full_image}"
        VERBATIM
    )

    # --- push target --------------------------------------------------------
    add_custom_target(push-${DI_NAME}
        COMMAND docker push "${_full_image}"
        COMMENT "Pushing Docker image ${_full_image}"
        VERBATIM
    )
    add_dependencies(push-${DI_NAME} build-${DI_NAME})

    # --- dependency wiring --------------------------------------------------
    foreach(_dep IN LISTS DI_DEPENDS)
        add_dependencies(build-${DI_NAME} build-${_dep})
    endforeach()
endfunction()
