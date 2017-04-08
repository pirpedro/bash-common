#!/bin/bash

load test_helper/helper

function setup(){
  TMP_SCRIPT="$(mktemp $HOME/tmp/focaXXXXX)"
  echo "#!/bin/bash
source ../sh-common
  " >> "$TMP_SCRIPT"
  chmod +x "$TMP_SCRIPT"
}

function teardown(){
  [ ! -f "$TMP_SCRIPT" ] || rm "$TMP_SCRIPT"
}

@test "usage - simple use" {
  echo "usage" >> "$TMP_SCRIPT"
  run "$TMP_SCRIPT"
  assert_output "usage: $(basename $TMP_SCRIPT) "
}

@test "usage - changing command name" {
  new_name="new_command_name"
  echo "usage $new_name" >> $TMP_SCRIPT
  run "$TMP_SCRIPT"
  assert_output "usage: $new_name "
}

@test "usage - defining usage information" {
  usage_info="some information about the script."
  echo "USAGE=\"$usage_info\"
usage" >> $TMP_SCRIPT
  run "$TMP_SCRIPT"
  assert_output "usage: $(basename $TMP_SCRIPT) $usage_info"
}

@test "usage - long usage version" {
  long_usage="long information about the script"
  echo "LONG_USAGE=\"$long_usage\"
usage" >> $TMP_SCRIPT
  run "$TMP_SCRIPT"
  assert_equal "${lines[0]}" "usage: $(basename $TMP_SCRIPT) "
  assert_equal "${lines[1]}" "  $long_usage"
}

@test "usage - using short and long version." {
  usage_info="some information about the script."
  long_usage="long information about the script."
  echo "USAGE=\"$usage_info\"
  LONG_USAGE=\"$long_usage\"
  usage" >> $TMP_SCRIPT
  run "$TMP_SCRIPT"
  assert_equal "${lines[0]}" "usage: $(basename $TMP_SCRIPT) $usage_info"
  assert_equal "${lines[1]}" "  $long_usage"
}

@test "usage - using '-h' flag" {
  #if you want to use -h flag and custom the output,
  #it's necessary to create USAGE and/or LONG_USAGE
  #before the inclusion of sh-common in the script.
  teardown
  touch $TMP_SCRIPT && chmod +x $TMP_SCRIPT
  usage_info="some information about the script."
  echo "#!/bin/bash
  USAGE=\"$usage_info\"
  source ../sh-common" >> $TMP_SCRIPT
  run $TMP_SCRIPT -h
  assert_output "usage: $(basename $TMP_SCRIPT) $usage_info"
}
