#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SOURCE_DIR/.." && pwd)"
SOURCE_FILE="$SOURCE_DIR/homesoc-status"
TARGET_FILE="/usr/local/bin/homesoc-status"
CONFIG_FILE="/etc/default/homesoc-status"

if [[ ! -f "$SOURCE_FILE" ]]; then
  printf 'Error: source utility not found at %s\n' "$SOURCE_FILE" >&2
  exit 1
fi

chmod +x "$SOURCE_FILE"

if [[ -w "$(dirname "$TARGET_FILE")" ]]; then
  install -m 0755 "$SOURCE_FILE" "$TARGET_FILE"
else
  sudo install -m 0755 "$SOURCE_FILE" "$TARGET_FILE"
fi

printf -v CONFIG_CONTENT 'HOMESOC_REPO=%q' "$REPO_DIR"

if [[ -w "$(dirname "$CONFIG_FILE")" ]]; then
  printf '%s\n' "$CONFIG_CONTENT" > "$CONFIG_FILE"
else
  printf '%s\n' "$CONFIG_CONTENT" | sudo tee "$CONFIG_FILE" >/dev/null
fi

printf 'Installed homesoc-status to %s\n' "$TARGET_FILE"
printf 'Configured HOMESOC_REPO=%s in %s\n' "$REPO_DIR" "$CONFIG_FILE"
