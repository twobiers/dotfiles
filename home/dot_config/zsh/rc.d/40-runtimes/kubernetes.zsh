export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

source <(kubie generate-completion zsh)

# Don't inherit KUBECONFIG from parent shells (e.g. inside a kubie shell);
# kubie manages context switching itself, starship/kubectl fall back to ~/.kube/config
# — but never clobber a kubie shell's own KUBECONFIG, or the first prompt in a
# freshly spawned kubie shell shows the wrong context
[[ -n "$KUBIE_KUBECONFIG" ]] || unset KUBECONFIG


# kubectl function to edit a configmap in a temporary file
# Usage: kf <configmap> [-n namespace] [-c context]
kf() {
  local ns="default" ctx="" cm=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -n|--namespace) ns="$2"; shift 2 ;;
      -c|--context)   ctx="$2"; shift 2 ;;
      *) cm="$1"; shift ;;
    esac
  done

  if [ -z "$cm" ]; then
    echo "usage: kf <configmap> [-n namespace] [-c context]" >&2
    return 1
  fi

  local ctx_args=()
  [ -n "$ctx" ] && ctx_args=(--context "$ctx")

  local key
  key=$(kubectl get cm "$cm" -n "$ns" "${ctx_args[@]}" -o json | jq -r '.data | keys[]' | fzf --prompt="key> ")
  [ -n "$key" ] || return

  local tmpfile="/tmp/${cm}-${key}"
  kubectl get cm "$cm" -n "$ns" "${ctx_args[@]}" -o json | jq -r --arg k "$key" '.data[$k]' > "$tmpfile"
  ${=EDITOR} "$tmpfile"
}

__completion_kf() {
  local -a namespaces contexts configmaps
  local curcontext="$curcontext" state line
  local ns="default" ctx=""

  # scan already-typed args for -n/-c to scope configmap completion
  for (( i=1; i <= CURRENT; i++ )); do
    case "${words[i]}" in
      -n|--namespace) ns="${words[i+1]}" ;;
      -c|--context)   ctx="${words[i+1]}" ;;
    esac
  done

  _arguments -C \
    '(-n --namespace)'{-n,--namespace}'[namespace]:namespace:->namespaces' \
    '(-c --context)'{-c,--context}'[context]:context:->contexts' \
    '1:configmap:->configmaps'

  case $state in
    namespaces)
      namespaces=(${(f)"$(kubectl get ns -o name 2>/dev/null | sed 's|namespace/||')"})
      _describe 'namespace' namespaces
      ;;
    contexts)
      contexts=(${(f)"$(kubectl config get-contexts -o name 2>/dev/null)"})
      _describe 'context' contexts
      ;;
    configmaps)
      local ctx_args=()
      [[ -n "$ctx" ]] && ctx_args=(--context "$ctx")
      configmaps=(${(f)"$(kubectl get cm -n "$ns" "${ctx_args[@]}" -o name 2>/dev/null | sed 's|configmap/||')"})
      _describe 'configmap' configmaps
      ;;
  esac
}

znap fpath _kf '__completion_kf'
