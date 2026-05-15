#!/usr/bin/env bash

set -euo pipefail

function interactive_login() {
  if [[ $(pass-cli test &>/dev/null && echo $?) != 0 ]]; then
    pass-cli login --interactive
  fi
}

# pass-cli is already installed, so we can skip this setup script
type pass-cli >/dev/null 2>&1 && {
  interactive_login
  exit 0
}

curl -fsSL https://proton.me/download/pass-cli/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"

interactive_login
