#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/lib.sh"

function pass-cli:login() {
  log::debug "Checking pass-cli session..."
  if [[ $(pass-cli info &>/dev/null && echo $?) != 0 ]]; then
    log::debug "Not logged in, running pass-cli login"

    # If PROTON_PASS_PAT is set, use it to login non-interactively
    if [[ -n "${PROTON_PASS_PERSONAL_ACCESS_TOKEN:-}" ]]; then
      log::debug "Using PROTON_PASS_PERSONAL_ACCESS_TOKEN for non-interactive login"
    else
      log::debug "No PROTON_PASS_PAT found, falling back to interactive login"
    fi
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
  retry 3 2 pass-cli ssh-agent load
}

function chezmoi:fetch_age_key() {
  KEY_DIR="$HOME/.config/age"
  KEY_FILE="key-chezmoi.txt"

  PROTON_VAULT_NAME="Personal"
  PROTON_ITEM_NAME="age-key-chezmoi"
  PROTON_FIELD_NAME="KEY"
  PROTON_ITEM_URI="pass://$PROTON_VAULT_NAME/$PROTON_ITEM_NAME/$PROTON_FIELD_NAME"

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

for tool in pass-cli; do
  if ! command -v $tool &> /dev/null; then
    log::info "$tool not found, installing..."
    $tool:install
  else
    log::debug "$tool is already installed."
    log::debug "$(command -v $tool)"
  fi
done

pass-cli:login

if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
  log::debug "No SSH agent found, starting one"
  eval "$(ssh-agent -s)" > /dev/null
fi

if ! ssh-add -l &> /dev/null; then
  log::debug "No SSH identities found in ssh-agent, attempting to load from pass-cli"
  pass-cli:load-ssh-keys
else
  log::debug "SSH identities already loaded in ssh-agent"
fi

chezmoi:fetch_age_key
