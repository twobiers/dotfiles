#!/bin/bash
set -eufo pipefail

# shellcheck source=../../lib/lib.sh
source "${CHEZMOI_SOURCE_DIR}/lib/lib.sh"

log::info "Installing nano syntax highlighting"
"$HOME/.local/share/nano-syntax-highlighting/install.sh"
