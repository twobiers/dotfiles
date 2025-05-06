eval "$(gh copilot alias -- zsh)"
eval "$(just --completions zsh)"

if type "logcli" &> /dev/null; then
  znap eval logcli 'logcli --completion-script-zsh'
fi
