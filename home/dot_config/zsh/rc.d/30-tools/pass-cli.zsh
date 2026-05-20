#!/usr/bin/env zsh

if [[ $(which pass-cli &>/dev/null && echo $?) == 0 ]]; then
  znap fpath _pass-cli 'pass-cli completions zsh'
fi
