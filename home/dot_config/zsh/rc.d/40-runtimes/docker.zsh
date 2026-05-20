#!/usr/bin/env zsh

# Docker helpers
drun() {
    docker run --rm -it -P -v "$(pwd):/xd" --entrypoint /bin/sh $@
}
