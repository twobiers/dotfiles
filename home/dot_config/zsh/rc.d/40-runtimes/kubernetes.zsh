export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Don't inherit KUBECONFIG from parent shells (e.g. inside a kubie shell);
# kubie manages context switching itself, starship/kubectl fall back to ~/.kube/config
unset KUBECONFIG

