#!/usr/bin/env zsh

if [[ $(which pass-cli &>/dev/null && echo $?) == 0 ]]; then
  eval "$(pass-cli completions zsh)"
fi
