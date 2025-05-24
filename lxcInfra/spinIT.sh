#!/bin/bash

# If no container name provided, list available ones
if [ -z "$1" ]; then
  echo "🧾 Available LXC containers:"
  lxc list --format csv -c n,s | column -t -s,
  echo
  echo "Usage:"
  echo "  $0 <container-name> [host-folder[:container-path] ...]"
  exit 0
fi

CONTAINER="$1"
shift

XSOCK="/tmp/.X11-unix"
XDEV_NAME="X0"

# Ensure container exists
if ! lxc list --format csv -c n | grep -qx "$CONTAINER"; then
  echo "❌ Container '$CONTAINER' does not exist."
  exit 1
fi

# Start container if not running
STATE=$(lxc info "$CONTAINER" | awk '/^Status:/ {print $2}')
if [ "$STATE" != "Running" ]; then
  echo "⚙️  Starting container '$CONTAINER'..."
  lxc start "$CONTAINER"
  sleep 2
fi

# Allow local X connections
xhost +local:

# Add X11 socket mount if missing
if ! lxc config device show "$CONTAINER" | grep -q "^  $XDEV_NAME:"; then
  echo "🔧 Adding X11 socket mount..."
  lxc config device add "$CONTAINER" "$XDEV_NAME" disk source="$XSOCK" path="$XSOCK"
fi

# Optional: Add shared folders
while [[ $# -gt 0 ]]; do
  HOST_SRC="${1%%:*}"
  CONTAINER_DST="${1##*:}"

  # If only host path given, default container mount to /mnt/<basename>
  if [[ "$HOST_SRC" == "$CONTAINER_DST" ]]; then
    CONTAINER_DST="/mnt/$(basename "$HOST_SRC")"
  fi

  # Use clean basename for device name (alphanumeric + _)
  DEV_NAME="$(basename "$HOST_SRC" | tr -c a-zA-Z0-9 _)"
  echo "🔗 Adding shared folder: $HOST_SRC → $CONTAINER_DST"

  lxc config device add "$CONTAINER" "$DEV_NAME" disk source="$HOST_SRC" path="$CONTAINER_DST"

  shift
done

# Launch interactive shell with DISPLAY set
echo "🚀 Launching shell in container '$CONTAINER'..."
lxc exec "$CONTAINER" --env DISPLAY=:0 -- bash
