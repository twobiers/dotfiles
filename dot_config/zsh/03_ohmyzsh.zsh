#!/usr/bin/env bash

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  # docker
  # docker-compose
  # kubectl
  fzf
  zsh-256color
  # fzf-tab
  gpg-agent
  # zsh-shift-select
  # zsh-autosuggestions
  zsh-autocomplete
  zsh-completions
  # zsh-syntax-highlighting
  fast-syntax-highlighting
  zoxide
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh
