#!/usr/bin/env zsh

zinit ice from"gh-r" as"command" atload'eval "$(starship init zsh)"'
zinit load starship/starship

# if is_in_path "starship"; then
#   eval "$(starship init zsh)"
# fi
