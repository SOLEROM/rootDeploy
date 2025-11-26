#!/usr/bin/env bash
# Simple helper to build/run a dev Docker container for Python + GUI work.
# Usage examples:
#   ./dev-container.sh                       # open interactive shell
#   ./dev-container.sh python3 src/myDroneKit.py --isSim
#   IMAGE_NAME=mib:dev ./dev-container.sh python3 src/myDroneKit.py --isSim
#
# You can override most vars using env vars when calling the script.

set -euo pipefail

# ---------- Configurable defaults (edit per-project) ----------

# Docker image + container names
IMAGE_NAME="${IMAGE_NAME:-mydev:latest}"       
CONTAINER_NAME="${CONTAINER_NAME:-myDev}"

# Path to env file with global defs (GST_KEY, MB_PLATFORM, etc.)
ENV_FILE="${ENV_FILE:-./mb_env.list}"

# Project root on host to mount inside container
HOST_PROJECT_DIR="${HOST_PROJECT_DIR:-$PWD}"
CONTAINER_PROJECT_DIR="${CONTAINER_PROJECT_DIR:-/home/dev/workspace}"

# Extra volume bindings (space-separated, each already formatted as -v host:container)
# Example (in your shell): EXTRA_VOLUMES="-v /home/user/file:/etc/file"
EXTRA_VOLUMES="${EXTRA_VOLUMES:-}"

# Pass your current UID into the container (so files created match host user)
HOST_UID="${HOST_UID:-$(id -u)}"

# Display / GUI support: use host DISPLAY, share /tmp for X11 sockets
DISPLAY_VAR="${DISPLAY_VAR:-${DISPLAY:-:0}}"

# Network & IPC mode
NET_MODE="${NET_MODE:-host}"       # you can change to "bridge" if you want
IPC_MODE="${IPC_MODE:-host}"

# Remove container when it exits
AUTO_REMOVE="${AUTO_REMOVE:---rm}"

# ---------- Helpers ----------

image_exists() {
    docker image inspect "${IMAGE_NAME}" >/dev/null 2>&1
}

build_image_if_needed() {
    if image_exists; then
        echo "Image ${IMAGE_NAME} already exists, skipping build."
    else
        echo "Image ${IMAGE_NAME} not found. Building..."
        docker build \
            --build-arg UID="${HOST_UID}" \
            --build-arg GID="${HOST_UID}" \
            -t "${IMAGE_NAME}" .
        echo "Image ${IMAGE_NAME} built."
    fi
}

check_env_file() {
    if [[ -n "${ENV_FILE}" && ! -f "${ENV_FILE}" ]]; then
        echo "WARNING: ENV_FILE '${ENV_FILE}' not found. Skipping --env-file."
        ENV_FILE=""
    fi
}

# ---------- Main run logic ----------

build_image_if_needed
check_env_file

# If no command provided, default to interactive bash
if [[ $# -eq 0 ]]; then
    CMD=(/bin/bash)
else
    CMD=("$@")
fi

# Base docker run args
RUN_ARGS=(
    -it
    ${AUTO_REMOVE}
    --name "${CONTAINER_NAME}"
    --ipc="${IPC_MODE}"
    --net="${NET_MODE}"
    -e DISPLAY="${DISPLAY_VAR}"
    -e UID="${HOST_UID}"
    -v /tmp:/tmp
    -v "${HOST_PROJECT_DIR}:${CONTAINER_PROJECT_DIR}"
)

# Add env-file if present
if [[ -n "${ENV_FILE}" ]]; then
    RUN_ARGS+=(--env-file "${ENV_FILE}")
fi

# Append extra volumes if defined
if [[ -n "${EXTRA_VOLUMES}" ]]; then
    # shellcheck disable=SC2206
    EXTRA_ARR=(${EXTRA_VOLUMES})
    RUN_ARGS+=("${EXTRA_ARR[@]}")
fi

echo "Running container:"
echo "  Image:      ${IMAGE_NAME}"
echo "  Name:       ${CONTAINER_NAME}"
echo "  Host dir:   ${HOST_PROJECT_DIR}"
echo "  Container:  ${CONTAINER_PROJECT_DIR}"
echo "  Env file:   ${ENV_FILE:-<none>}"
echo "  DISPLAY:    ${DISPLAY_VAR}"
echo "  CMD:        ${CMD[*]}"

docker run "${RUN_ARGS[@]}" "${IMAGE_NAME}" "${CMD[@]}"

