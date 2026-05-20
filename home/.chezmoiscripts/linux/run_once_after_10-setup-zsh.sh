#!/bin/bash
set -eufo pipefail

# shellcheck disable=SC1091
source "${CHEZMOI_SOURCE_DIR}/../lib/lib.sh"

log::info "Begin Setting Up Zsh"

export SHELL=/usr/bin/zsh
chsh -s /usr/bin/zsh

log::info "Finish Setting Up Zsh"
