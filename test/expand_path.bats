#!/usr/bin/env bash

load test_helper/helper

@test "expand_path - no argument" {
  run expand_path && assert_failure
}

@test "expand_path - empty argument" {
  file=""
  run expand_path "$file" && assert_failure
}

@test "expand_path - path without expansion need" {
  file="/path/to/file"
  run expand_path "$file" && assert_success
  assert_output "$file"
}

@test "expand_path - only a filename" {
  file="path/to/testname"
  run expand_path "$file" && assert_success
  assert_output "$(pwd)/$file"
}

@test "expand_path - '~' expansion" {
  file="~/path/to/file"
  run expand_path "$file" && assert_success
  assert_output "$HOME/path/to/file"
}

@test "expand_path - '~+' expansion" {
  file="~+/path/to/file"
  run expand_path "$file" && assert_success
  assert_output "$(pwd)/path/to/file"
}
