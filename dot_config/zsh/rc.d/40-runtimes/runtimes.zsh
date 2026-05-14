#!/usr/bin/env zsh

# Rust
export PATH="${PATH}:${HOME}/.cargo/bin"

# Go
export PATH="${PATH}:${HOME}/go/bin"
export PATH="${PATH}:/usr/local/go/bin"

# Java (sdkman)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Rancher Desktop
[[ -d "$HOME/.rd/bin" ]] && export PATH="$HOME/.rd/bin:$PATH"

# Docker helpers
drun() {
    docker run --rm -it -P -v "$(pwd):/xd" --entrypoint /bin/sh $@
}
