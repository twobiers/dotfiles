#!/usr/bin/env bash
set -euo pipefail

KEY_DIR="$HOME/.config/age"
KEY_FILE="key-chezmoi.txt"

PROTON_SHARE_ID="X_M6w23O_e6V4TXnHmnWjLL0NLwfJCE9FdktOeH_cav3ya8irRyzQpyazRzdh6Sv8JjLpCCNfdOr9M2vHAjRHg=="
PROTON_ITEM_ID="j9P3ympW5t9M8JrAVWr4ducXN0zGoBVhJlr3ZXDZzwLUi9WSwDQKKHlUIXp0aSQCN9hcGeZ20RwN9SgIDd2NIg=="
PROTON_FIELD_NAME="KEY"
PROTON_ITEM_URI="pass://$PROTON_SHARE_ID/$PROTON_ITEM_ID/$PROTON_FIELD_NAME"

function pass-cli:login() {
  if [[ $(pass-cli test &>/dev/null && echo $?) != 0 ]]; then
    pass-cli login
  fi
}

function pass-cli:install() {
  curl -fsSL https://proton.me/download/pass-cli/install.sh | bash
  export PATH="$HOME/.local/bin:$PATH"
}

function chezmoi:fetch_age_key() {
  if [ -f "$KEY_DIR/$KEY_FILE" ]; then
    echo " Key file already exists at $KEY_DIR/$KEY_FILE. Skipping to prevent overwriting."
    return
  fi

  mkdir -p "$KEY_DIR" || true

  pass-cli item view "$PROTON_ITEM_URI" > "$KEY_DIR/$KEY_FILE" || {
    echo "Error: Failed to retrieve the key from pass-cli or write to $KEY_DIR/$KEY_FILE."
    exit 1
  }
}

# pass-cli is already installed, so we can skip this setup script
type pass-cli >/dev/null 2>&1 && {
  pass-cli:login
  chezmoi:fetch_age_key
  exit 0
}

pass-cli:install
pass-cli:login
chezmoi:fetch_age_key
