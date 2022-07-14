# Setup fzf
# ---------
if [[ ! "$PATH" == */home/tobi/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/tobi/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/tobi/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/tobi/.fzf/shell/key-bindings.bash"
