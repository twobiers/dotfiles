#!/usr/bin/env zsh

# cursor moved to the end in full completion
setopt always_to_end

# hash everything before completion
setopt hash_list_all

# allow completion in the word
setopt complete_in_word

# don't correct
setopt nocorrect

# complete as much of a completion until it gets ambiguous.
setopt list_ambiguous

# Don't treat non-executable files in your $path as commands.
setopt hash_executables_only

setopt nolisttypes
setopt listpacked
setopt automenu

unsetopt correct_all
unsetopt correct
