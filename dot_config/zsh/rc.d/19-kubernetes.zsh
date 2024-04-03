export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

if [[ `which stern &>/dev/null` != 0 ]]; then
  # eval "$(zoxide init zsh)"
  znap eval stern 'stern --completion zsh'
fi

if [[ `which flux &>/dev/null` != 0 ]]; then
  znap eval flux 'flux completion zsh'
fi
