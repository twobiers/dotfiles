#!/usr/bin/env zsh

# History
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"

HIST_STAMPS="yyyy-mm-dd"
SAVEHIST=290000
HISTSIZE=$((1.2 * SAVEHIST))

# record timestamp of command in HISTFILE
setopt extended_history

# delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_expire_dups_first

# ignore duplicated commands history list
setopt hist_ignore_all_dups

# show command with history expansion to user before running it
setopt hist_verify

# add commands to HISTFILE in order of execution
setopt inc_append_history

# Use modern file-locking mechanisms, for better safety & performance.
setopt HIST_FCNTL_LOCK

# Auto-sync history between concurrent sessions.
setopt share_history
