# TODO
goatcd() {
  if [ "$#" -eq '1' ] && [ "$1" = "-" ]; then
    command cd - 2>/dev/null
  else
    command cd "$@" 2>/dev/null || goat "$1"
  fi
}

alias cd='goatcd'

