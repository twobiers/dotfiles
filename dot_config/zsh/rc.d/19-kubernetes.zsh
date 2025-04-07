export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

if type "stern" &> /dev/null; then
  # eval "$(zoxide init zsh)"
  znap eval stern 'stern --completion zsh'
fi

if type "flux" &> /dev/null; then
  znap eval flux 'flux completion zsh'
fi

if type "chainsaw" &> /dev/null; then
  znap eval chainsaw 'chainsaw completion zsh'
fi

[ -f "$HOME/.local/share/fubectl/fubectl.source" ] && source "$HOME/.local/share/fubectl/fubectl.source"
