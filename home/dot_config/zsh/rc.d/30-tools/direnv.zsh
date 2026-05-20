#!/usr/bin/env zsh

# znap eval direnv "direnv hook zsh"

if [[ -x direnv ]]; then
  eval "$(direnv hook zsh)"
fi
