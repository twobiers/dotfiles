#!/usr/bin/env zsh

if [[ $(which devenv &>/dev/null && echo $?) == 0 ]]; then
  eval "$(devenv hook zsh)"
fi
