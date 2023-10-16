#!/usr/bin/env zsh

znap source ohmyzsh/ohmyzsh \
  lib/{clipboard,compfix,completion,correction,directories,functions,git,grep,history,spectrum,termsupport} \
  plugins/{aws,brew,fzf,git}

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
znap source unixorn/fzf-zsh-plugin

znap source Aloxaf/fzf-tab
zstyle ':fzf-tab:*' fzf-pad 6
