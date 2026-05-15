#!/bin/bash
set -eufo pipefail

# shellcheck source=../lib.sh
source "${CHEZMOI_SOURCE_DIR}/.chezmoiscripts/lib.sh"

log::info "Installing nano syntax highlighting"
"$HOME/.local/share/nano-syntax-highlighting/install.sh"
