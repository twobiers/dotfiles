#!/usr/bin/env bash

# Use fd if installed
if [[ -x fd ]]; then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --color=always'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

export FZF_DEFAULT_OPTS="--ansi --height 40% --border"
export FZF_CTRL_R_OPTS="$FZF_DEFAULT_OPTS --no-preview"

if [[ -x bat ]]; then
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --style=numbers --color=always --line-range :500 {}'"
  alias fp='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
fi

gli() {
  local filter
  if [ -n "$@" ] && [ -f "$@" ]; then
    filter="-- $@"
  fi
  git log \
    --graph --color=always --abbrev=7 --format='%C(auto)%h %an %C(blue)%s %C(yellow)%cr' "$@" |
    fzf \
      --ansi --no-sort --reverse --tiebreak=index --height 80% --preview-window=right:60% \
      --preview "f() { set -- \$(echo -- \$@ | grep -o '[a-f0-9]\{7\}'); [ \$# -eq 0 ] || git show --color=always \$1 $filter; }; f {}" \
      --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
                FZF-EOF"
}

fglog() { # git log browser with FZF
  git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf \
      --ansi \
      --bind=ctrl-s:toggle-sort \
      --no-sort \
      --reverse \
      --tiebreak=index \
      --bind "ctrl-m:execute:\
    (grep -o '[a-f0-9]\{7\}' \
      | head -1 \
      | xargs -I % sh -c 'git show --color=always % \
      | less -R'
  ) << 'FZF-EOF' {} FZF-EOF"
}
