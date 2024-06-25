_az_zsh_completer_path="/opt/homebrew/etc/bash_completion.d/az"

[[ -r $_az_zsh_completer_path ]] && autoload -U +X bashcompinit && bashcompinit && source $_az_zsh_completer_path