#!/usr/bin/env bash

export NVM_COMPLETION=true
export NVM_SYMLINK_CURRENT="true"
export NVM_DIR="$HOME/.nvm"

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && znap eval nvm "source $NVM_DIR/bash_completion"

if test -f $HOME/.bun/bin/bun; then
  export PATH="$PATH:$HOME/.bun/bin/"
fi
