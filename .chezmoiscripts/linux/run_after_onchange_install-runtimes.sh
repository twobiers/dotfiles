#!/bin/bash

set -euo pipefail

# shellcheck source=../lib.sh
source "${CHEZMOI_SOURCE_DIR}/.chezmoiscripts/lib.sh"

log::info "Installing/updating global runtimes via mise"

mise use -g go@latest
mise use -g node@latest
mise use -g python@latest
mise use -g uv@latest
mise use -g java@temurin
