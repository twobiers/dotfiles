#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/lib.sh"

function pass-cli:login() {
  log::debug "Checking pass-cli session..."
  if [[ $(pass-cli test &>/dev/null && echo $?) != 0 ]]; then
    log::debug "Not logged in, running pass-cli login"
    pass-cli login
  else
    log::debug "Already logged in"
  fi
}

function pass-cli:install() {
  log::info "Installing pass-cli from Proton installer script"
  curl -fsSL https://proton.me/download/pass-cli/install.sh | bash
  export PATH="$HOME/.local/bin:$PATH"
  log::debug "pass-cli installed, PATH updated to include $HOME/.local/bin"
}

function pass-cli:load-ssh-keys() {
  log::debug "Loading SSH keys from pass-cli vault"
  pass-cli ssh-agent load
}

function chezmoi:fetch_age_key() {
  KEY_DIR="$HOME/.config/age"
  KEY_FILE="key-chezmoi.txt"

  PROTON_SHARE_ID="X_M6w23O_e6V4TXnHmnWjLL0NLwfJCE9FdktOeH_cav3ya8irRyzQpyazRzdh6Sv8JjLpCCNfdOr9M2vHAjRHg=="
  PROTON_ITEM_ID="j9P3ympW5t9M8JrAVWr4ducXN0zGoBVhJlr3ZXDZzwLUi9WSwDQKKHlUIXp0aSQCN9hcGeZ20RwN9SgIDd2NIg=="
  PROTON_FIELD_NAME="KEY"
  PROTON_ITEM_URI="pass://$PROTON_SHARE_ID/$PROTON_ITEM_ID/$PROTON_FIELD_NAME"

  log::debug "Fetching age key to $KEY_DIR/$KEY_FILE"

  if [ -f "$KEY_DIR/$KEY_FILE" ]; then
    log::info "Key file already exists at $KEY_DIR/$KEY_FILE. Skipping to prevent overwriting."
    return
  fi

  log::debug "Key file not found, creating $KEY_DIR and retrieving from pass-cli"
  mkdir -p "$KEY_DIR" || true

  pass-cli item view "$PROTON_ITEM_URI" > "$KEY_DIR/$KEY_FILE" || {
    log::error "Failed to retrieve the key from pass-cli or write to $KEY_DIR/$KEY_FILE."
    exit 1
  }
  log::debug "Age key written to $KEY_DIR/$KEY_FILE"
}

function yq:install() {
  VERSION=v4.2.0
  PLATFORM=linux_amd64
  log::info "Installing yq $VERSION for $PLATFORM"

  curl -fsSL https://github.com/mikefarah/yq/releases/download/${VERSION}/yq_${PLATFORM}.tar.gz |\
    tar xz && sudo mv yq_${PLATFORM} /usr/local/bin/yq
  log::debug "yq installed to /usr/local/bin/yq"
}

function jq:install() {
  VERSION=jq-1.8.1
  PLATFORM=linux-amd64
  log::info "Installing jq $VERSION for $PLATFORM"

  curl -fsSL https://github.com/jqlang/jq/releases/download/${VERSION}/jq-${PLATFORM} |\
    sudo tee /usr/local/bin/jq && sudo chmod +x /usr/local/bin/jq
  log::debug "jq installed to /usr/local/bin/jq"
}

for tool in pass-cli yq jq; do
  if ! command -v $tool &> /dev/null; then
    log::info "$tool not found, installing..."
    $tool:install
  else
    log::debug "$tool is already installed."
    log::debug "$(command -v $tool)"
  fi
done

pass-cli:login
pass-cli:load-ssh-keys
chezmoi:fetch_age_key
