function is_in_path {
  if [[ -n $ZSH_VERSION ]]; then
    builtin whence -p "$1" &>/dev/null
  else # bash:
    builtin type -P "$1" &>/dev/null
  fi
}
