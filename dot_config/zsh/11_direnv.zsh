#!/usr/bin/env zsh

zinit as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
  atpull'%atclone' pick"direnv" src"zhook.zsh" for \
  direnv/direnv

# if [[ -x direnv ]]; then
#   eval "$(direnv hook zsh)"
# fi
