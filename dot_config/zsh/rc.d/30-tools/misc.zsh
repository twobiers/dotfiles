if type "just" &> /dev/null; then
  eval "$(just --completions zsh)"
fi

if type "logcli" &> /dev/null; then
  znap eval logcli 'logcli --completion-script-zsh'
fi
