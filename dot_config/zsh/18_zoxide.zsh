#!/usr/bin/env zsh

zinit ice from"gh-r" as"command" atload'eval "$(zoxide init zsh)"'
zinit load ajeetdsouza/zoxide

# if is_in_path "zoxide"; then
#   eval "$(zoxide init zsh)"
# fi
