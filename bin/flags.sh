#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source $DIR/../helper/globals.sh
### END IMPORT ###

flag(){ local varname="FLAG_$1"; [ "${!varname}" == "${FLAG_TRUE}" ]; }

unset_flag(){ if empty "$1"; then return ${FLAG_ERROR}; fi; unset "FLAG_$1"; }

set_flag(){
  if empty "$1"; then return ${FLAG_ERROR}; fi
  local flag
  flag=${2:-$FLAG_TRUE}
  if check_boolean "$flag"; then
    eval "FLAG_$1=${FLAG_TRUE}";
  else
    unset_flag "$1"
  fi
}

set_global_flag(){
  local flag
  flag=${2:-${FLAG_TRUE}}
  if check_boolean "${flag}"; then
    export "FLAG_$1=${FLAG_TRUE}";
  else
    unset_flag "$1"
  fi
}
