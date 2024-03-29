#!/usr/bin/env bash

# shellcheck disable=SC2034

#Colors
NC=`echo -e "\033[0m"`
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
ORANGE="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
LGRAY="\033[0;37m"
DGRAY="\033[1;30m"
LRED="\033[1;31m"
LGREEN="\033[1;32m"
YELLOW="\033[1;33m"
LBLUE="\033[1;34m"
LPURPLE="\033[1;35m"
LCYAN="\033[1;36m"
WHITE="\033[1;37m"

#flags
FLAG_TRUE=0
FLAG_FALSE=1
FLAG_ERROR=2
#ask_color=`echo -e ${GREEN}`
#warn_color=`echo -e ${YELLOW}`
#note_color=`echo -e ${CYAN}`
#highlight=`echo -e ${WHITE}`
question_color=${GREEN}
warn_color=${YELLOW}
note_color=${CYAN}
highlight=${WHITE}

QUESTION_FLAG="${question_color}?"
WARN_FLAG="${warn_color}!"
NOTE_FLAG="${note_color}❯"

#check if a variable is empty
empty(){ [ -z "$1" ]; }

#check if a file is empty
empty_file(){
  if [ -f "$1" ]; then
    [ ! -s $1 ]
  else
    return ${FLAG_ERROR}
  fi
}

#string matchings
startswith() { [ "$1" != "${1#$2}" ]; }
endswith() { [ "$1" != "${1%$2}" ]; }
equals() { [ "$1" == "$2" ]; }
contains() {
  if empty "$1" || empty "$2"; then return ${FLAG_FALSE}; fi
  case "$1" in
    *$2* ) return ${FLAG_TRUE}; ;;
    * ) return ${FLAG_FALSE}; ;;
  esac
}

to_upper() { echo "$1" | tr '[:lower:]' '[:upper:]'; }
to_lower() { echo "$1" | tr '[:upper:]' '[:lower:]';}

check_boolean(){
  case "$1" in
    [yY] | [yY][eE][sS] | [oO][nN] | ${FLAG_TRUE} ) return ${FLAG_TRUE} ; ;;
    [nN] | [nN][oO] | [oO][fF][fF] | ${FLAG_FALSE} ) return ${FLAG_FALSE}; ;;
    * ) return ${FLAG_ERROR}; ;;
  esac
}

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
die(){ die_with_status 1 "$@"; }
die_with_status () {
	status=$1
	shift
	printf "$*\n" >&2
	exit "$status"
}

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

if equals "$1" "-h"; then
  usage
  exit
fi

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

location(){
  case $(uname -s) in
  Linux)
  	echo $(dirname "$(readlink -e "$1")")
  	;;
  FreeBSD|OpenBSD|NetBSD)
  	echo $(dirname "$(realpath "$1")")
  	;;
  Darwin)
  	PRG="$1"
  	while [ -h "$PRG" ]; do
  		link=$(readlink "$PRG")
  		if expr "$link" : '/.*' > /dev/null; then
  			PRG="$link"
  		else
  			PRG="$(dirname "$PRG")/$link"
  		fi
  	done
  	echo $(dirname "$PRG")
  	;;
  *MINGW*)
  	echo $(dirname "$(echo "$1" | sed -e 's,\\,/,g')")
  	pwd () {
  		builtin pwd -W
  	}
  	;;
  *)
  	echo $(dirname "$(echo "$1" | sed -e 's,\\,/,g')")
  	;;
  esac
}

flag(){ local varname="FLAG_$1"; [ "${!varname}" == "${FLAG_TRUE}" ]; }
unset_flag(){ if empty "$1"; then return ${FLAG_ERROR}; fi; unset "FLAG_$1"; }
set_flag(){
  if empty "$1"; then return ${FLAG_ERROR}; fi
  local flag
  flag=${2:-$FLAG_TRUE}
  if check_boolean "$flag"; then
    eval "FLAG_$1=$FLAG_TRUE";
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

empty_output(){
  [ "$( "$@" | wc -c )" -eq 0 ]
}

#generate a random value
random(){
  local length=${1:-8}
  local pattern=${2:-"A-Za-z0-9_"}
	echo "$(cat /dev/urandom | base64 | tr -dc $pattern | head -c$length)"
}

#random number generator
function rng {
  local number length=${1:-3}
  number=`random $length "0-9_" | sed -e "s/^[0]*//"`
  if empty "$number"; then
    number=0;
  fi
  echo "$number"
}

function mktmp_file {
  # Give preference to user tmp directory for security
  if [ -e "$HOME/tmp" ];then
    TEMP_DIR="$HOME/tmp"
  else
    TEMP_DIR="/tmp"
  fi

  #Construct a "safe" temp file using mktemp
  TEMP_FILE=$(mktemp "$TEMP_DIR/mytmp.XXXXXXXXXXXXXXXX")
  echo "$TEMP_FILE"
}

# Function that sets certain environment variables to known values
function clear_vars {
    # Save the old variables so that they can be restored
    OLD_IFS="$IFS"
    OLD_PATH="$PATH"

    # Set the variables to known safer values
  #  IFS=$' tn' #Set IFS to include whitespace characters
}

# Function that restores environment variables to what the were at the
# start of the script.
function restore_vars {
  IFS="$OLD_IFS"
  PATH="$OLD_PATH"
}

# Function to clean up after ourselves
function clean_up {
  local TMP_FILE
  if [ -e "$HOME/tmp" ];then
    TEMP_DIR="$HOME/tmp"
  else
    TEMP_DIR="/tmp"
  fi

  # Step through and delete all of the temp files
  for TMP_FILE in $(ls "$TEMP_DIR" | grep mytmp.)
  do
      # Make sure that the tempfile exists
      if [ -e "$TEMP_DIR/$TMP_FILE" ]; then
        rm "$TEMP_DIR/$TMP_FILE"
      fi
  done

  # Reset the variables to their original values
  restore_vars
}

function is_link {
  [ ! -z "$1" ] || die "No argument passed to $0 function."
  #shopt -s dotglob
  [ -L "$1" ]
}

function zipf {
  [ ! -z "$1" ] || die "No argument passed to $0 function."
  zip -r "$1".zip "$1"
}

function extract {
  [ ! -z "$1" ] || die "No argument passed to $0 function."
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)     die "'$1' cannot be extracted via extract()" ;;
    esac
  else
    die "'$1' is not a valid file."
  fi
}

function expand_path {
  ! empty "$1" || die "No argument passed to expand_path."
  local path="$1"
  case "$1" in
    "~+"/*)
      path=$PWD/${path#"~+/"}
      ;;
    "~-"/*)
      path=$OLDPWD/${path#"~-/"}
      ;;
    "~"/*)
      path=$HOME/${path#"~/"}
      ;;
    "~"*)
      username=${path%%/*}
      username=${username#"~"}
      local IFS=: read _ _ _ _ _ homedir _ < <(getent passwd "$username")
      if [[ $path = */* ]]; then
        path=${homedir}/${path#*/}
      else
        path=$homedir
      fi
      ;;
  esac

  if ! startswith "$path" "/"; then
    path="$(pwd)/$path"
  fi
  echo "$path"
}

# Make sure that we delete the temp files when we exit
trap 'clean_up' EXIT
clear_vars

# Holds common script debugging functionality

# Set the PS4 variable to add line #s to our debug output
PS4='Line $LINENO : '

_DEBUG=0 #debug starts off

# The function that enables the enabling/disabling of
# debugging in the script.
function DEBUG_WATCH() {
  [ ! -z "$1" ] || { echo "Nothing to watch."; exit 1; }
  PS4='Line ${BASH_LINENO[$i]} : '
  set -x
  "$@"
  set +x
  PS4='Line $LINENO : '
}

function DEBUG {
  set +x
  if [[ "$_DEBUG" -eq 0 ]]; then
    _DEBUG=1
    set -x
  else
    set +x
    _DEBUG=0
  fi
}

# to_alternatives transforms a multiline list of strings into a single line
# string with the words separated by '|'.
to_alternatives() {
  local parts=( $1 )
  local IFS='|'
  echo "${parts[*]}"
}

__to_extglob() {
  local extglob=$( to_alternatives "$1" )
  echo "$2($extglob)"
}


extglob_on() {
  __previous_extglob_settings=$(shopt -p extglob)
  shopt -s extglob
}

extglob_restore() {
  eval "$__previous_extglob_settings"
  unset __previous_extglob_settings
}

# to_extglob transforms a multiline list of options into an extglob pattern
# suitable to use in case statements.
case_zero_or_one() {
  __to_extglob "$1" "?"
}

case_zero_or_more() {
  __to_extglob "$1" "*"
}

case_one_or_more() {
  __to_extglob "$1" "+"
}

case_one(){
  __to_extglob "$1" "@"
}

case_not() {
  __to_extglob "$1" "!"
}
