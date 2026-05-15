#!/usr/bin/env zsh

if (( ! $+commands[mise] )); then
  return
fi

znap eval mise 'mise activate zsh'
# Requires usage CLI, which I don't want to use right now.
# znap fpath _mise 'mise completion zsh'
