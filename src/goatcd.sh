# TODO
goatcd() {
  command cd "$@" 2>/dev/null || goat "$1"
}

alias cd='goatcd'

