_az_zsh_completer_path="/etc/bash_completion.d/azure-cli"

[[ -r $_az_zsh_completer_path ]] && autoload -U +X bashcompinit && bashcompinit && source $_az_zsh_completer_path