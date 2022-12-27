# Workarounds for https://youtrack.jetbrains.com/issue/TBX-4599
# IDEA
_idea="$(command -v idea)"
if [[ -x "${_idea}" ]]; then
  function idea() {
    { "${_idea}" "$@" & } &>/dev/null
    disown
  }
fi

# GoLand
_goland="$(command -v goland)"
if [[ -x "${_goland}" ]]; then
  function goland() {
    { "${_goland}" "$@" & } &>/dev/null
    disown
  }
fi

# Rider
_rider="$(command -v rider)"
if [[ -x "${_rider}" ]]; then
  function rider() {
    { "${_rider}" "$@" & } &>/dev/null
    disown
  }
fi

# CLion
_clion="$(command -v clion)"
if [[ -x "${_clion}" ]]; then
  function clion() {
    { "${_clion}" "$@" & } &>/dev/null
    disown
  }
fi

# DataGrip
_datagrip="$(command -v datagrip)"
if [[ -x "${_datagrip}" ]]; then
  function datagrip() {
    { "${_datagrip}" "$@" & } &>/dev/null
    disown
  }
fi
