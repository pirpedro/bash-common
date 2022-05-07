#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source $DIR/../helper/globals.sh
source $DIR/flags.sh
### END IMPORT ###

#outputs
verbosity(){
   if check_boolean "$1"; then
      set_global_flag verbosity
   fi
}

log(){
  local force
  for arg do
    shift
    case "$arg" in
      -f | --force) force=${FLAG_TRUE} ;;
      *) set -- "$@" "$arg" ;;
    esac
  done
  ! flag verbosity && test -z "$force" || echo "$@";
}

#
# Generate colored message, conditional do verbose mode
# and accept highlight with pattern '__PATTERN__'
#
# Params
# --color=<value>
# --flag=<value>
# --highlight=<value> default value ${highlight}
__notify(){
  local color flag
  for arg do
    shift
    case "$arg" in
      --color=* )
          color=`echo -e ${arg##--color=}`; ;;
      --flag=* )
          flag=`echo -e ${arg##--flag=}`; ;;
      --highlight=* ) local highlight_color=${arg##--highlight=}; ;;
      *) set -- "$@" "$arg"; ;;
    esac
  done
  highlight_color=`echo -e ${highlight_color:-$highlight}`
  msg="$arg" #msg is the last element of iteration
  set -- "${@:1:$(($#-1))}" #remove last argument
  msg=`sed -r "s/(__)([^_]+)(__)/${highlight_color}\2${color}/g;" <<< "$msg"`
  log -e "$@" "${flag}$msg${NC}"
}

note(){ __notify --color="${note_color}" --flag="${NOTE_FLAG}" "$@"; }
question(){ __notify --color="${question_color}" --flag="${QUESTION_FLAG}" "$@"; }
warn(){ __notify --color="${warn_color}" --flag="${WARN_FLAG}" "$@";}

