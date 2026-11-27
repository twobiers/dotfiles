export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

source <(kubie generate-completion zsh)

# kubie's generated completion only knows flags, not context names.
# Wrap it: complete `kubie ctx <TAB>` from every kubeconfig file kubie
# discovers (same globs as ~/.kube/kubie.yaml), delegating everything
# else to the generated completion.
functions[_kubie_generated]=$functions[_kubie]
_kubie() {
  if (( CURRENT == 3 )) && [[ ${words[2]} == ctx ]]; then
    local -a files contexts
    files=(~/.kube/config ~/.kube/*(N.))
    files=(${files:#*/.*} ${files:#*/kubie.yaml})
    contexts=(${(f)"$(KUBECONFIG=${(j.:.)files} kubectl config get-contexts -o name 2>/dev/null)"})
    _describe -t kubie-contexts 'kubernetes context' contexts
  else
    _kubie_generated "$@"
  fi
}
compdef _kubie kubie

# Don't inherit KUBECONFIG from parent shells (e.g. inside a kubie shell);
# kubie manages context switching itself, starship/kubectl fall back to ~/.kube/config
# — but never clobber a kubie shell's own KUBECONFIG, or the first prompt in a
# freshly spawned kubie shell shows the wrong context
[[ -n "$KUBIE_KUBECONFIG" ]] || unset KUBECONFIG


# --- MRU context ordering ----------------------------------------------------
# Kubie's interactive menu is a skim widget inside the binary; its listing
# order (kubeconfig scan order) can't be changed from config. Instead, the
# start_ctx hook in ~/.kube/kubie.yaml appends every context entry to
# $KCTX_HISTORY, and the kubie() wrapper below routes the bare interactive
# picker through an MRU-sorted fzf list. kubie still performs the actual
# switch, so session history (`kubie ctx -`), namespace restore, and prompt
# handling are untouched.

typeset -g KCTX_HISTORY="$HOME/.local/state/kubie/context-history"

__kctx_log() {
  emulate -L zsh
  mkdir -p "$HOME/.local/state/kubie" 2>/dev/null
  printf '%s\t%s\n' "$(date +%s)" "$1" >> "$KCTX_HISTORY"
}

# Same enumeration as kubie's completion wrapper above.
__kctx_list() {
  emulate -L zsh
  local -a files
  files=(~/.kube/config ~/.kube/*(N.))
  files=(${files:#*/.*} ${files:#*/kubie.yaml})
  KUBECONFIG=${(j.:.)files} kubectl config get-contexts -o name 2>/dev/null
}

# Contexts most-recently-used first; never-used last, alphabetical.
__kctx_order() {
  emulate -L zsh
  local -A last
  local t c now ts d age
  now=$(date +%s)
  if [[ -f "$KCTX_HISTORY" ]]; then
    while IFS=$'\t' read -r t c; do
      [[ "$t" == <-> ]] || continue
      (( ${last[$c]:-0} < t )) && last[$c]=$t
    done < "$KCTX_HISTORY"
  fi
  local -a rows
  for c in $(__kctx_list); do
    ts=${last[$c]:-0}
    age="-"
    if (( ts > 0 )); then
      d=$(( now - ts ))
      if (( d < 3600 )); then age="$(( d / 60 ))m"
      elif (( d < 86400 )); then age="$(( d / 3600 ))h"
      else age="$(( d / 86400 ))d"
      fi
    fi
    rows+=("$(printf '%012d\t%s\t%s' "$ts" "$c" "$age")")
  done
  printf '%s\n' "${rows[@]}" | sort -t$'\t' -k1,1r -k2,2 | cut -f2,3
}

# Interactive MRU context picker; kubie performs the switch.
kctx() {
  emulate -L zsh
  [[ -n "$(__kctx_list)" ]] || { print -u2 "kctx: no kubernetes contexts found"; return 1 }
  local sel
  # fzf options mirror the fzf block in ~/.kube/kubie.yaml; --mouse omitted:
  # removed in current fzf, mouse is on by default
  sel=$(__kctx_order | fzf --height=33% --tabstop=40 --prompt='ctx> ') || return 0
  [[ -n "$sel" ]] || return 0
  local ctx="${sel%%$'\t'*}"
  __kctx_log "$ctx"
  command kubie ctx "$ctx"
}

# Bare `kubie ctx` gets the MRU picker. `kubie ctx <name>` passes through but
# is logged, so in-shell switches (no shell spawn, hence no start_ctx hook)
# still count as usage. Everything else is untouched.
kubie() {
  emulate -L zsh
  if [[ "$1" != "ctx" ]]; then
    command kubie "$@"
    return
  fi
  shift
  local -a rest=("$@")
  local name="" i
  for (( i = 1; i <= ${#rest}; i++ )); do
    case "${rest[$i]}" in
      -n|--namespace) (( i++ )) ;;
      -)  name="-"; break ;;
      -*) ;;
      *)  name="${rest[$i]}"; break ;;
    esac
  done
  if [[ -z "$name" ]]; then
    if (( ${#rest} )); then
      command kubie ctx "${rest[@]}"
    else
      kctx
    fi
    return
  fi
  [[ "$name" != "-" ]] && __kctx_log "$name"
  command kubie ctx "${rest[@]}"
}


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
