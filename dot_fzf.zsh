# Setup fzf
# ---------
if [[ ! "$PATH" == */home/tobi/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/tobi/.fzf/bin"
fi

# Auto-completion
# ---------------
if test -f "/usr/share/fzf/completion.zsh"; then
  source "/usr/share/fzf/completion.zsh"
fi

[[ $- == *i* ]] && source "/home/tobi/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
if test -f "/usr/share/fzf/key-bindings.zsh"; then
  source "/usr/share/fzf/key-bindings.zsh"
fi

if test -f "/home/tobi/.fzf/shell/key-bindings.zsh"; then
  source "/home/tobi/.fzf/shell/key-bindings.zsh"
fi

# Use fd if installed
if [[ -x fd ]]; then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --color=always'
  export FZF_DEFAULT_OPTS="--ansi"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
