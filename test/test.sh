#!/bin/sh
# vim: ts=2 sw=2 sts=2:
#
# A testing suite for goat.
#

readonly kGOATHERD="../goatherd"

set -eu

gTEST_CASE=''

gts_goatherd() {
  "$kGOATHERD" "$@"
}

gts_goat() {
  sh "$kGOAT_PATH/goat.sh" "$@"
}

gts_fail_test_case() {
  printf "failed test case '%s'\n" "$gTEST_CASE"
  exit 1
}

gts_test_absolute() {
  gTEST_CASE='absolute 1'
  cd "$kTEST_DIR"
  prevdir="$(pwd)"
  gts_goat test0 .
  cd root1/home2
  [ "$(gts_goat test0)" = "$prevdir" ] || gts_fail_test_case

  gTEST_CASE='absolute 2'
  cd "$kTEST_DIR"
  prevdir="$(pwd)"
  gts_goat test0 "$prevdir"
  cd root1/home2
  [ "$(gts_goat test0)" = "$prevdir" ] || gts_fail_test_case
}

mkdir -p root1/home2/Projects3/torch4
gts_goatherd clean
gts_goatherd target

readonly kGOAT_PATH="$(cd "$(dirname ../target/goat.sh)" && pwd)"
readonly kTEST_DIR="$(cd "$(dirname "$0")" && pwd)"

gts_test_absolute

cd "$kTEST_DIR"
rm -rf ./root1
gts_goatherd clean

printf "all tests passed\n"
