#!/usr/bin/env zsh

export -U PATH path FPATH fpath

path=(
  "$HOME/.bin"
  "$HOME/.local/bin"
  "$HOME/.scripts"
  "$HOME/.local/share/JetBrains/Toolbox/scripts"
  "$HOME/bin"
  "/usr/local/bin"
  $path
)

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

if is_in_path "bat"; then
  export PAGER=bat
  export MANPAGER="sh -c 'sed -e s/.\\\\x08//g | bat -l man -p'"
fi
