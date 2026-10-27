#!/usr/bin/env bash

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


if type "docker" &> /dev/null; then
  export DOCKER_BUILDKIT=1
  export COMPOSE_DOCKER_CLI_BUILD=1
fi

# In a VS Code integrated terminal, open files in the existing window;
# otherwise use a terminal editor. --wait blocks until the file is closed.
if [[ "$TERM_PROGRAM" == "vscode" ]] && type "code" &>/dev/null; then
  export EDITOR="code --wait"
elif type "micro" &>/dev/null; then
  export EDITOR="micro"
elif type "code" &>/dev/null; then
  export EDITOR="code --wait"
fi

if type "bat" &> /dev/null; then
  export PAGER="bat"
  export MANPAGER="sh -c 'sed -e s/.\\\\x08//g | bat -l man -p'"
fi
