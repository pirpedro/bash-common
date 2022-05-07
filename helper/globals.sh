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

to_upper() { echo "$1" | tr '[:lower:]' '[:upper:]'; }
to_lower() { echo "$1" | tr '[:upper:]' '[:lower:]';}

die(){ die_with_status 1 "$@"; }
die_with_status () {
	status=$1
	shift
	printf "$*\n" >&2
	exit "$status"
}

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

empty_output(){
  [ "$( "$@" | wc -c )" -eq 0 ]
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

check_boolean(){
  case "$1" in
    [yY] | [yY][eE][sS] | [oO][nN] | ${FLAG_TRUE} ) return ${FLAG_TRUE} ; ;;
    [nN] | [nN][oO] | [oO][fF][fF] | ${FLAG_FALSE} ) return ${FLAG_FALSE}; ;;
    * ) return ${FLAG_ERROR}; ;;
  esac
}

function is_link {
  [ ! -z "$1" ] || die "No argument passed to $0 function."
  #shopt -s dotglob
  [ -L "$1" ]
}


