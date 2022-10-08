# Setup fzf
# ---------
if [[ ! "$PATH" == */home/tobi/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/tobi/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/tobi/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
if test -f "/home/tobi/.fzf/shell/key-bindings.zsh"; then
  source "/home/tobi/.fzf/shell/key-bindings.zsh"
fi
