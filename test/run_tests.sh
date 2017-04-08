#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
cd "$BASEDIR" || exit 1

if [ ! -z "$1" ]; then
  files="$(basename $1)"
else
  files="."
fi
bats "$files"
