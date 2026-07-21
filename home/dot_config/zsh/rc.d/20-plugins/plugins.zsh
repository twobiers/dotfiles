#!/usr/bin/env zsh

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/ohmyzsh"
mkdir -p "$ZSH_CACHE_DIR"
mkdir -p "$ZSH_CACHE_DIR/completions"

znap source ohmyzsh/ohmyzsh \
  lib/{clipboard,compfix,directories} \
  plugins/{git,golang,helm,kind,kubectl,podman,ssh,systemd,terraform}

znap source zsh-users/zsh-completions

znap source chrissicool/zsh-256color
znap source zdharma-continuum/fast-syntax-highlighting

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste accept-line)
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(widget::key-ctrl-right)
znap source zsh-users/zsh-autosuggestions

# zstyle ':autocomplete:*' fzf-completion yes
# zstyle ':autocomplete:recent-dirs' backend zoxide
# znap source marlonrichert/zsh-autocomplete
znap eval trapd00r/LS_COLORS "$(whence -a dircolors gdircolors) -b LS_COLORS"

# Could be useful eventually, but right now I am not using it.
# znap source unixorn/fzf-zsh-plugin

# Must be loaded after fzf-zsh-plugin
# znap source atuinsh/atuin

znap source Aloxaf/fzf-tab
zstyle ':fzf-tab:*' fzf-pad 6

znap source MichaelAquilina/zsh-you-should-use

# We could use carapace for completions which has some cool concepts, but it doesn't pair well
# atm. Give it a shot later.
# source <(carapace _carapace)
