export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

if is_in_path "stern"; then
  # eval "$(zoxide init zsh)"
  znap eval stern 'stern --completion zsh'
fi