#!/bin/bash
set -eufo pipefail

# shellcheck source=../lib.sh
source "${CHEZMOI_SOURCE_DIR}/.chezmoiscripts/lib.sh"

log::info "Begin Setting Up Zsh"

export SHELL=/usr/bin/zsh
chsh -s /usr/bin/zsh

log::info "Finish Setting Up Zsh"
