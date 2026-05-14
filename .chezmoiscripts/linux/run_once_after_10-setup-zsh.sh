#!/bin/bash
set -eufo pipefail

echo "\033[0;32m>>>>> Begin Setting Up Zsh <<<<<\033[0m"

export SHELL=/usr/bin/zsh
chsh -s /usr/bin/zsh

echo "\033[0;32m>>>>> Finish Setting Up Zsh <<<<<\033[0m"
