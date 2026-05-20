#!/usr/bin/env zsh

# eval "$(starship init zsh --print-full-init)"
# znap prompt

# For some reason this doesn't work when using the znap eval, so we cache the output manually.
# znap eval starship 'starship init zsh --print-full-init'
local cache=${XDG_CACHE_HOME:-~/.cache}/starship/init.zsh
[[ -s $cache && $cache -nt =starship ]] || {
  mkdir -p $cache:h && starship init zsh --print-full-init >| $cache
}
source $cache
znap prompt
