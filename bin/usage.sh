#!/usr/bin/env bash

#for a better use of USAGE functionalities
#we recommend to instantiate the variables
#USAGE and/or LONG_USAGE before sourcing sh-common
#in your script.
dashless=$(basename -- "${0%.*}" | sed -e 's/-/ /g')
usage() {
  local cmd_name
  cmd_name=${1:-$dashless}
  if [ -z "$LONG_USAGE" ]; then
    echo "usage: $cmd_name $USAGE"
  else
    echo "usage: $cmd_name $USAGE

  $LONG_USAGE"
  fi
}

if [ "$1" == "-h" ]; then
  usage
  exit
fi