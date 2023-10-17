#!/usr/bin/env bash

export NVM_COMPLETION=true
export NVM_SYMLINK_CURRENT="true"
export NVM_DIR="$HOME/.nvm"

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm


if test -f /usr/share/nvm/init-nvm.sh; then
  source /usr/share/nvm/init-nvm.sh
fi

if test -f $HOME/.bun/bin/bun; then
  export PATH="$PATH:$HOME/.bun/bin/"
fi
