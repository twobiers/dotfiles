#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source "${CHEZMOI_SOURCE_DIR}/../lib/lib.sh"

log::info "Installing/updating global runtimes via mise"

mise use -g go@latest
mise use -g node@latest
mise use -g python@latest
mise use -g uv@latest
mise use -g java@temurin
