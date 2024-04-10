#!/usr/bin/env zsh

# znap eval zoxide 'zoxide init zsh'

if [[ $(which zoxide &>/dev/null && echo $?) == 0 ]]; then
  eval "$(zoxide init zsh)"
fi
