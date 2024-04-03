#!/usr/bin/env zsh

# znap eval zoxide 'zoxide init zsh'

if [[ `which zoxide &>/dev/null` != 0 ]]; then
  eval "$(zoxide init zsh)"
fi
