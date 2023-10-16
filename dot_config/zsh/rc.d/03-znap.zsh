#!/usr/bin/env zsh

# Download Znap, if it's not there yet.
[[ -r ~/.local/share/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.local/share/znap
source ~/.local/share/znap/znap.zsh  # Start Znap

zstyle ':znap:*' plugins-dir "$HOME/.local/share/zsh/plugins"
