#!/usr/bin/env zsh

if [[ $(which pass-cli &>/dev/null && echo $?) == 0 ]]; then
  znap eval pass-cli "$(pass-cli completions zsh)"
fi
