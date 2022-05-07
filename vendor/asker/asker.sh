#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source $DIR/../../helper/globals.sh
source $DIR/../../bin/flags.sh
#
# Make a question
#
# Params:
#
# --question=<value>         question string
# --options=<value>          a comma separated string with options
# --default=<default_value>   choose a default answer throught options list
# --boolean                  create a boolean (yes|no) question
#
ask(){
  unset ask_answer
  local ask_default_value question_msg options
  for arg do
    shift
    case "$arg" in
      --question=* )
          question_msg=${arg##--question=}; ;;
      --options=* )
          options=${arg##--options=}; ;;
      --default=* ) ask_default_value=${arg##--default=}; ;;
      --boolean ) options="yes,no"; ask_default_value=${ask_default_value:-"yes"}; ;;
      --free-answer ) set_flag free; ;;
    esac
  done
  if empty "$options" && ! empty "$ask_default_value"; then
    options="$ask_default_value"
  fi
  if empty "$question_msg" || ( empty "$options" && ! flag free ); then
    return ${FLAG_ERROR}
  fi
  options_string=`sed -r 's/,/|/g' <<< "$options"`
  question -f -n "${question_msg} [${options_string}]: "
  read answer
  answer=${answer:-$ask_default_value}
  old_ifs=${IFS}; IFS=","; array=($options); IFS=${old_ifs}
  for ((i = 0; i < ${#array[@]}; i++)); do
    if startswith "${array[i]}" "${answer}"; then
      export ask_answer=${array[i]}
      return ${FLAG_TRUE}
    fi
  done
  if flag free; then
    export ask_answer=${answer:-$ask_default_value}
    unset_flag free
    return ${FLAG_TRUE}
  fi
  export ask_answer=${ask_default_value}
  return ${FLAG_TRUE}
}

#
# Create a boolean question
#
# ask_boolean "msg" [FLAG_TRUE-default|FLAG_FALSE]
#
# check answer "yes" or "no" in variable ask_answer
ask_boolean(){
  local msg=$1
  local default=${2:-$FLAG_TRUE}
  local default_string
  if check_boolean "$default"; then
    default_string="yes"
  else
    default_string="no"
  fi
  ask --question="$msg" --default="${default_string}" --boolean
  check_boolean "${ask_answer}"
}