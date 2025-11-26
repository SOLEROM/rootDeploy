#!/usr/bin/env bash
# devRunner.sh - build and run a dev Docker container with subcommands.
#
# Subcommands:
#   ./devRunner.sh build [options]
#   ./devRunner.sh run [options] -- CMD...
#   ./devRunner.sh shell [options]
#
# Shortcuts:
#   ./devRunner.sh python3 src/myDroneKit.py --isSim
#       -> treated as: run -- python3 src/myDroneKit.py --isSim

set -euo pipefail

# ---------- Global defaults (override via env or per-project edits) ----------

IMAGE_NAME="${IMAGE_NAME:-mydev:latest}"       # e.g. mib:dev
CONTAINER_NAME="${CONTAINER_NAME:-myDev}"

DOCKERFILE="${DOCKERFILE:-Dockerfile}"         # default Dockerfile path

ENV_FILE="${ENV_FILE:-./mb_env.list}"

HOST_PROJECT_DIR="${HOST_PROJECT_DIR:-$PWD}"
CONTAINER_PROJECT_DIR="${CONTAINER_PROJECT_DIR:-/home/dev/workspace}"

EXTRA_VOLUMES="${EXTRA_VOLUMES:-}"             # e.g. "-v /host/file:/container/file"

HOST_UID="${HOST_UID:-$(id -u)}"

DISPLAY_VAR="${DISPLAY_VAR:-${DISPLAY:-:0}}"

NET_MODE="${NET_MODE:-host}"
IPC_MODE="${IPC_MODE:-host}"

AUTO_REMOVE="${AUTO_REMOVE:---rm}"             # change to "" if you want to keep containers

# ---------- Helpers ----------

usage() {
    cat <<EOF
Usage:
  $(basename "$0") build [options]
      -f, --file DOCKERFILE   Dockerfile path (default: ${DOCKERFILE})
      -t, --tag IMAGE_NAME    Image name:tag (default: ${IMAGE_NAME})

  $(basename "$0") run [options] -- [COMMAND...]
      --env-file FILE         Env file (default: ${ENV_FILE})
      --host-dir DIR          Host project dir (default: ${HOST_PROJECT_DIR})
      --container-dir DIR     Container project dir (default: ${CONTAINER_PROJECT_DIR})
      --extra-volumes STR     Extra "-v host:cont" entries as a single string
      --display DISPLAY       DISPLAY value (default: ${DISPLAY_VAR})
      --name NAME             Container name (default: ${CONTAINER_NAME})
      --net MODE              Docker network mode (default: ${NET_MODE})
      --ipc MODE              Docker IPC mode (default: ${IPC_MODE})
      -f, --file DOCKERFILE   Dockerfile path when auto-building

      If COMMAND is omitted, runs an interactive shell.

  $(basename "$0") shell [options]
      Same options as 'run', but always drops into a shell.

Shortcut:
  $(basename "$0") python3 src/myDroneKit.py --isSim
      -> treated as: $(basename "$0") run -- python3 src/myDroneKit.py --isSim
EOF
}

image_exists() {
    docker image inspect "${IMAGE_NAME}" >/dev/null 2>&1
}

build_image() {
    local dockerfile="$1"

    if [[ ! -f "${dockerfile}" ]]; then
        echo "ERROR: Dockerfile '${dockerfile}' not found." >&2
        exit 1
    fi

    echo "Building image '${IMAGE_NAME}' using Dockerfile '${dockerfile}'..."
    docker build \
        --build-arg UID="${HOST_UID}" \
        --build-arg GID="${HOST_UID}" \
        -f "${dockerfile}" \
        -t "${IMAGE_NAME}" .
    echo "Image '${IMAGE_NAME}' built."
}

build_image_if_needed() {
    local dockerfile="$1"
    if image_exists; then
        echo "Image ${IMAGE_NAME} already exists, skipping build."
    else
        build_image "${dockerfile}"
    fi
}

check_env_file() {
    if [[ -n "${ENV_FILE}" && ! -f "${ENV_FILE}" ]]; then
        echo "WARNING: ENV_FILE '${ENV_FILE}' not found. Skipping --env-file."
        ENV_FILE=""
    fi
}

run_container() {
    local dockerfile_for_autobuild="$1"; shift

    # Ensure image exists
    build_image_if_needed "${dockerfile_for_autobuild}"
    check_env_file

    local host_dir="${HOST_PROJECT_DIR}"
    local cont_dir="${CONTAINER_PROJECT_DIR}"
    local extra_volumes="${EXTRA_VOLUMES}"
    local display="${DISPLAY_VAR}"
    local cname="${CONTAINER_NAME}"
    local net_mode="${NET_MODE}"
    local ipc_mode="${IPC_MODE}"

    # Parse run options until we hit "--" or end
    local args=("$@")
    local run_opts=()
    local cmd=()
    local parsing_opts=1
    local i=0

    while [[ $i -lt ${#args[@]} ]]; do
        local token="${args[$i]}"
        if [[ ${parsing_opts} -eq 1 ]]; then
            case "${token}" in
                --env-file)
                    ENV_FILE="${args[$((i+1))]}"
                    i=$((i+2))
                    continue
                    ;;
                --host-dir)
                    host_dir="${args[$((i+1))]}"
                    i=$((i+2))
                    continue
                    ;;
                --container-dir)
                    cont_dir="${args[$((i+1))]}"
                    i=$((i+2))
                    continue
                    ;;
                --extra-volumes)
                    extra_volumes="${args[$((i+1))]}"
                    i=$((i+2))
                    continue
                    ;;
                --display)
                    display="${args[$((i+1))]}"
                    i=$((i+2))
                    continue
                    ;;
                --name)
                    cname="${args[$((i+1))]}"
                    i=$((i+2))
                    continue
                    ;;
                --net)
                    net_mode="${args[$((i+1))]}"
                    i=$((i+2))
                    continue
                    ;;
                --ipc)
                    ipc_mode="${args[$((i+1))]}"
                    i=$((i+2))
                    continue
                    ;;
                -f|--file)
                    dockerfile_for_autobuild="${args[$((i+1))]}"
                    i=$((i+2))
                    continue
                    ;;
                --no-rm)
                    AUTO_REMOVE=""
                    i=$((i+1))
                    continue
                    ;;
                --)
                    parsing_opts=0
                    i=$((i+1))
                    continue
                    ;;
                *)
                    # first non-option token becomes the start of CMD
                    parsing_opts=0
                    continue
                    ;;
            esac
        else
            # after "--" or first non-option: everything is CMD
            :
        fi

        if [[ ${parsing_opts} -eq 0 ]]; then
            cmd+=("${token}")
        fi
        i=$((i+1))
    done

    # Default command: /bin/bash
    if [[ ${#cmd[@]} -eq 0 ]]; then
        cmd=(/bin/bash)
    fi

    # (Re)check env file after flags may have changed it
    check_env_file

    local run_args=(
        -it
        ${AUTO_REMOVE}
        --name "${cname}"
        --ipc="${ipc_mode}"
        --net="${net_mode}"
        -e DISPLAY="${display}"
        -e UID="${HOST_UID}"
        -v /tmp:/tmp
        -v "${host_dir}:${cont_dir}"
    )

    if [[ -n "${ENV_FILE}" ]]; then
        run_args+=(--env-file "${ENV_FILE}")
    fi

    if [[ -n "${extra_volumes}" ]]; then
        # shellcheck disable=SC2206
        local extra_arr=(${extra_volumes})
        run_args+=("${extra_arr[@]}")
    fi

    echo "Running container:"
    echo "  Image:      ${IMAGE_NAME}"
    echo "  Name:       ${cname}"
    echo "  Host dir:   ${host_dir}"
    echo "  Container:  ${cont_dir}"
    echo "  Env file:   ${ENV_FILE:-<none>}"
    echo "  DISPLAY:    ${display}"
    echo "  CMD:        ${cmd[*]}"

    docker run "${run_args[@]}" "${IMAGE_NAME}" "${cmd[@]}"
}

# ---------- Subcommand dispatcher ----------

if [[ $# -eq 0 ]]; then
    usage
    exit 0
fi

subcommand="$1"
shift || true

case "${subcommand}" in
    build)
        # devRunner.sh build [ -f DOCKERFILE ] [ -t IMAGE:TAG ]
        dockerfile="${DOCKERFILE}"
        while [[ $# -gt 0 ]]; do
            case "$1" in
                -f|--file)
                    dockerfile="$2"
                    shift 2
                    ;;
                -t|--tag)
                    IMAGE_NAME="$2"
                    shift 2
                    ;;
                *)
                    echo "Unknown build option: $1" >&2
                    usage
                    exit 1
                    ;;
            esac
        done
        build_image "${dockerfile}"
        ;;

    run)
        # devRunner.sh run [options] -- CMD...
        run_container "${DOCKERFILE}" "$@"
        ;;

    shell)
        # devRunner.sh shell [options]
        run_container "${DOCKERFILE}" "$@"
        ;;

    help|-h|--help)
        usage
        ;;

    *)
        # Shortcut: treat as "run -- <subcommand> <rest>"
        set -- "${subcommand}" "$@"
        run_container "${DOCKERFILE}" "$@"
        ;;
esac

