#!/bin/sh
# vim: ts=2 sw=2 sts=2:
#
# leash - The missing link between your shell and goat.
#

# TODO
goat() {
  command cd "$(sh "$kINSTALLATION_DIR/$kGOAT" "$@")"
}
