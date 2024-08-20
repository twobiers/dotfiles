#!/usr/bin/env bash

drun() {
    docker run --rm -it -P -v "$(pwd):/xd" --entrypoint /bin/sh $@
}