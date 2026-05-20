#!/bin/bash
set -eufo pipefail

# shellcheck disable=SC1091
source "${CHEZMOI_SOURCE_DIR}/../lib/lib.sh"

NANORC_FILE="$HOME/.nanorc"
NANORC_SYNTAX_HIGHLIGHTING_DIR="$HOME/.local/share/nano-syntax-highlighting"

log::info "Installing nano syntax highlighting"
mkdir -p ~/.nano/
find $NANORC_SYNTAX_HIGHLIGHTING_DIR -name ".nanorc" -exec cp '{}' ~/.nano/ \; || true
touch "$NANORC_FILE"

while read -r inc; do
  if ! grep -q "$inc" "${NANORC_FILE}"; then
    echo "$inc" >> "$NANORC_FILE"
  fi
done < "$NANORC_SYNTAX_HIGHLIGHTING_DIR/nanorc"
