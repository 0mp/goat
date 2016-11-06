#!/bin/sh
# vim: ts=2 sw=2 sts=2:
#
# goat - A hacky shortcut utility for managing your shortcuts.
#
# Notes:
# - Don't put tabs in the names of your shortcuts, files and directories as it
#   will break the shortcut file.
#

readonly kSHORTCUTS_DIR="${kINSTALLATION_DIR:-"$(dirname "$0")"}"
readonly kSHORTCUTS="$kSHORTCUTS_DIR/$kSHORTCUTS_FILE"

set -eu

gEXIT_STATUS=0
gPROPOSED_PATH=''
gRESOLVED_PATH=''
gSHORTCUT=''

# TODO
gt_error() {
  >&2 printf "ERROR: %s\n" "$1"
}

# TODO
gt_warn() {
  >&2 printf "WARNING: %s\n" "$1"
}

gt_info() {
  >&2 printf "INFO: %s\n" "$1"
}

gt_echo() {
  printf "%s" "$1"
}

# Remove an absolute shortcut from a file. Do nothing if there is no such an
# absolute shortcut
# Variables:
#   $1 -> a shortcut for which we want to remove a matching entry
# TODO
gt_remove() {
  if sed -e "/^$gSHORTCUT[[:space:]]\//d" "$kSHORTCUTS" > "$kSHORTCUTS.bak"; then
    mv "$kSHORTCUTS.bak" "$kSHORTCUTS"
    gt_info "goat removed the '$gSHORTCUT' shortcut"
    return 0
  else
    gt_info "goat didn't remove '$gSHORTCUT'; maybe it doesn't exist?"
    return 1
  fi
}

# Show usage information
# TODO
gt_usage() {
  cat <<EOF
usage: goat [<shortcut> | <shortcut> <path> | please [<arg> ...]]
  options:
    <shortcut> <directory>
      -- create a <shortcut> to a <directory>
    <shortcut>
      -- go to a directory assigned to <shortcut>; if a <shortcut> consists of
         dots only then it will expand every '.' to '../'
  pleases:
    list shortcuts
      -- list all your saved shortcuts
    edit shortcuts
      -- edit all your saved shortcuts in an editor
    nuke shortcuts
      -- delete all saved shortcuts
    delete <shortcut>
      -- delete <shortcut> from your saved shortcuts
    help me
      -- print this help message
EOF
  gEXIT_STATUS=1
  return 1
}

# TODO
gt_resolve_as_absolute() {
  candidatepaths="$(grep -n "^$(gt_echo "$gSHORTCUT" | sed "s/\./\\\./g")	/" \
    "$kSHORTCUTS")"
  if [ -z "$candidatepaths" ]; then
    return 1
  fi
  case "$(printf "%s\n" "$candidatepaths" | wc -l | tr -d '[:space:]')" in
    '1')
      gRESOLVED_PATH="$(gt_echo "$candidatepaths" | cut -f2)"
      return 0
      ;;
    '0')
      return 1
      ;;
    '')
      return 1
      ;;
    *)
      gt_warn "goat found more than one destinations for the '$gSHORTCUT'" \
        "shortcut; the '$kSHORTCUTS' file is corrupted"
      return 1
      ;;
  esac
}

# TODO
gt_resolve_as_relative() {
  candidatepaths="$(grep -n "^$gSHORTCUT	\." "$kSHORTCUTS")"
  case "$(gt_echo "$candidatepaths" | wc -l | tr -d '[:space:]')" in
    '1')
      gRESOLVED_PATH="$(gt_echo "$candidatepaths" | cut -d"\t" -f2)"
      return 0
      ;;
    '0')
      return 1
      ;;
    *)
      gt_echo "$candidatepaths" | while read -r candidate; do
        gRESOLVED_PATH="$(gt_echo "$candidate" | cut -d"\t" -f2)"
        if [ -d "$gRESOLVED_PATH" ]; then
          return 0
        fi
      done
      gRESOLVED_PATH=''
      return 1
      ;;
  esac
}

# TODO
gt_resolve_as_dots() {
  if [ "$gSHORTCUT" != "$(gt_echo "$gSHORTCUT" | tr -d -c '.')" ]; then
    return 1
  fi

  # Now we know there are only dots in the shortcut.
  gRESOLVED_PATH="$(gt_echo "$gSHORTCUT" | sed 's/\.//' | sed 's/\./\.\.\//g')"

  if [ -z "$gRESOLVED_PATH" ]; then
    return 1
  fi
}


# Go to the destination.
# The order of the destination look up is the following:
#  - absolute shortcuts (e.g. /usr/bin)
#  - relatvie shortcuts (e.g. ../../test) and stop when you find a working one
#  - dot shortcuts (e.g. ...)
# Input:
#   $1 -> A shortcut which can be matched with a directory we want to go to.
# Returns:
#   - a path when we found a coresponding path for the given shortcut
#   - 1 when there was an error
gt_go() {
  gSHORTCUT="$1"

  # Try absolute shortcuts.
  if gt_resolve_as_absolute; then
    :
  elif gt_resolve_as_relative; then
    :
  elif gt_resolve_as_dots; then
    :
  else
    gt_error "goat doesn't know where '$gSHORTCUT' should lead to"
    gEXIT_STATUS=1
    return 1
  fi

  if [ ! -d "$gRESOLVED_PATH" ]; then
    gt_error "goat cannot reach the '$gRESOLVED_PATH' directory"
    gEXIT_STATUS=1
    return 1
  fi

  printf "%s\n" "$gRESOLVED_PATH"
}

# Create a new shortcut
# Variables:
#   $1 -> a new shortcut
#   $2 -> a path for the new shortcut
# Returns:
#   - 1 if there was an error
#   - 0 if everything was fine
# TODO
gt_create() {
  gSHORTCUT="$1"
  gPROPOSED_PATH="$2"

  if [ ! -d "$gPROPOSED_PATH" ]; then
    gt_error "goat thinks that '$gPROPOSED_PATH' isn't a valid path"
    gEXIT_STATUS=1
    return 1
  fi

  # Get the absolute path
  gRESOLVED_PATH="$(cd -- "$gPROPOSED_PATH" && pwd -P 2>/dev/null | pwd)"

  # Remove the old shortcut
  gt_remove 2>/dev/null

  # Add new shortcut
  printf "%s	%s\n" "$gSHORTCUT" "$gRESOLVED_PATH" >> "$kSHORTCUTS"

  return 0
}

# Administrate your goat
# Variables:
#   $1 -> "please"
#   $2, $3 -> depends
# Returns:
#   0, if everything went fine
#   1, if there was an error
gt_configure() {
  if [ ! "$1" = "please" ]; then
    printf "FAUX PAS: goat doesn't like that kind of tone\n" >&2
    gEXIT_STATUS=1
    return 1
  fi

  case "$2" in
    'delete')
      gSHORTCUT="$3"
      gt_remove || gEXIT_STATUS=1
      ;;
    'edit')
      if [ "$3" = "shortcuts" ]; then
        # shellcheck disable=SC2094
        $kEDITOR "$kSHORTCUTS" < "$(tty)" > "$(tty)" || gEXIT_STATUS=1
      fi
      ;;
    'help')
      if [ "$3" = "me" ]; then
        gt_usage
      fi
      ;;
    'list')
      if [ "$3" = "shortcuts" ]; then
        cat "$kSHORTCUTS" || gEXIT_STATUS=1
      fi
      ;;
    'nuke')
      if [ "$3" = "shortcuts" ]; then
        rm "$kSHORTCUTS" || gEXIT_STATUS=1
      fi
      ;;
    *)
      gt_error "goat just doesn't know what to do with itself"
      gEXIT_STATUS=1
      ;;
  esac

  return $gEXIT_STATUS
}

# Handle user input.
# Creates the shortcuts file if it does not exists.
gt_run() {
  # Test existance of the file with shortcuts
  [ -d "$kSHORTCUTS" ] || mkdir -p "$kSHORTCUTS_DIR"
  [ -f "$kSHORTCUTS" ] || touch "$kSHORTCUTS"

  case "$#" in
    '0')
      gt_usage
      ;;
    '1')
      gt_go "$1"
      ;;
    '2')
      gt_create "$1" "$2"
      ;;
    '3')
      gt_configure "$1" "$2" "$3"
      ;;
  esac

  exit "$gEXIT_STATUS"
}

gt_run "$@"
