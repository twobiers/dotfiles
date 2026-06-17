if [[ $(which codium &>/dev/null && echo $?) == 0 ]]; then
  alias code="codium"
fi