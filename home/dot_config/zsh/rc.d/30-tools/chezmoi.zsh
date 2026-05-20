#!/usr/bin/env bash

function chezmoi-cd() {
  cd $(chezmoi source-path)
}

znap fpath _chezmoi 'chezmoi completion zsh'
