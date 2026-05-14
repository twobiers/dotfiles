#!/bin/sh

set -euox pipefail

KEY_DIR="$HOME/.config/age"
KEY_FILE="key-chezmoi.txt"

PROTON_SHARE_ID="X_M6w23O_e6V4TXnHmnWjLL0NLwfJCE9FdktOeH_cav3ya8irRyzQpyazRzdh6Sv8JjLpCCNfdOr9M2vHAjRHg=="
PROTON_ITEM_ID="j9P3ympW5t9M8JrAVWr4ducXN0zGoBVhJlr3ZXDZzwLUi9WSwDQKKHlUIXp0aSQCN9hcGeZ20RwN9SgIDd2NIg=="
PROTON_FIELD_NAME="KEY"
PROTON_ITEM_URI="pass://$PROTON_SHARE_ID/$PROTON_ITEM_ID/$PROTON_FIELD_NAME"

type pass-cli >/dev/null 2>&1 || {
  echo "Error: pass-cli is not installed or not in PATH."
  exit 1
}

if [ -f "$KEY_DIR/$KEY_FILE" ]; then
  echo "Error: Key file already exists at $KEY_DIR/$KEY_FILE. Skipping to prevent overwriting."
  exit 0
fi

mkdir -p "$KEY_DIR" || true

pass-cli item view "$PROTON_ITEM_URI" > "$KEY_DIR/$KEY_FILE" || {
  echo "Error: Failed to retrieve the key from pass-cli or write to $KEY_DIR/$KEY_FILE."
  exit 1
}
