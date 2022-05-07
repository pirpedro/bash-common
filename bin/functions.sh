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

# Make sure that we delete the temp files when we exit
trap 'clean_up' EXIT
clear_vars