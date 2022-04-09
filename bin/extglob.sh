#!/usr/bin/env bash

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
