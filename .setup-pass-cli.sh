#!/bin/sh

set -euo pipefail

# pass-cli is already installed, so we can skip this setup script
type pass-cli >/dev/null 2>&1 || {
  exit 0
}

curl -fsSL https://proton.me/download/pass-cli/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"
