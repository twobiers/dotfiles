#!/usr/bin/env bash

if is_in_path "kubectl"; then
  alias k="kubectl"
fi

if is_in_path "git"; then
  alias g="git"
fi

if is_in_path "docker"; then
  alias d="docker"
fi

if is_in_path "bat"; then
  alias cat="bat --style=plain --paging=never"
fi

if is_in_path "exa"; then
  alias ls="exa"
  alias l="exa -abghHlS --git --group-directories-first"
  alias ll="exa -abghHlS --git --group-directories-first"
fi
