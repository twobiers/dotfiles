#!/usr/bin/env bash

if [[ $(which kubectl &>/dev/null && echo $?) == 0 ]]; then
  alias k="kubectl"
fi

if [[ $(which git &>/dev/null && echo $?) == 0 ]]; then
  alias g="git"
fi

if [[ $(which docker &>/dev/null && echo $?) == 0 ]]; then
  alias d="docker"
fi

if [[ $(which bat &>/dev/null && echo $?) == 0 ]]; then
  alias cat="bat --style=plain --paging=never"
fi

if [[ $(which eza &>/dev/null && echo $?) == 0 ]]; then
  alias ls="eza"
  alias l="eza -abghHlS --git --group-directories-first"
  alias ll="eza -abghHlS --git --group-directories-first"
fi
