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

if [[ -x bat ]]; then
  export PAGER=bat
fi
