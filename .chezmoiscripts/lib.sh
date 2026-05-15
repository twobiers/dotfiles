#!/usr/bin/env bash
# Shared logging library for chezmoi scripts. Source this file; do not execute it.

_chezmoi_log() {
  local color="$1" level="$2"
  shift 2
  if [[ -t 2 ]] && [[ -z "${NO_COLOR:-}" ]]; then
    printf "\033[%sm[%s]\033[0m %s\n" "$color" "$level" "$*" >&2
  else
    printf "[%s] %s\n" "$level" "$*" >&2
  fi
}

log::info()  { _chezmoi_log "0;32"  "INFO " "$@"; }
log::warn()  { _chezmoi_log "0;33"  "WARN " "$@"; }
log::error() { _chezmoi_log "0;31"  "ERROR" "$@"; }
log::debug() { [[ "${DEBUG:-0}" == "1" ]] && _chezmoi_log "0;36" "DEBUG" "$@" || true; }
