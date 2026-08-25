#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$SOURCE_DIR/homesoc-update"
TARGET_FILE="/usr/local/bin/homesoc-update"

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

printf 'Installed homesoc-update to %s\n' "$TARGET_FILE"
