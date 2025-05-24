# Dockerfile.final
ARG PYTHON_VERSION
ARG GCC_VERSION

# Use build arguments to decide which base to start from
FROM python-${PYTHON_VERSION} as python-base
FROM gcc-${GCC_VERSION} as gcc-base

# Final stage using selected Python and GCC images
FROM my-base-image:latest as final