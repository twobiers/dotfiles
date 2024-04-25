export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

local FOUND_STERN=$+commands[stern]
if [[ $FOUND_STERN -eq 1 ]]; then
  # eval "$(zoxide init zsh)"
  znap eval stern 'stern --completion zsh'
fi

local FOUND_FLUX=$+commands[flux]
if [[ $FOUND_FLUX -eq 1 ]]; then
  znap eval flux 'flux completion zsh'
fi
