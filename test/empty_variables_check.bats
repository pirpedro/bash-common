#!/bin/bash

load test_helper/helper

function setup(){
  TMP_FILE=$(mktmp_file)
}

function teardown(){
  [ ! -f $TMP_FILE ] || rm $TMP_FILE
}

@test "empty - simple variable without value" {
  local test_variable;
  run empty $test_variable
  assert_success
}
@test "empty - simple variable with value" {
  local test_variable="test value";
  run empty $test_variable
  assert_failure
}

@test "empty - not declared variable" {
  run empty $test_variable
  assert_success
}

@test "empty - empty string" {
  local test_variable="";
  run empty $test_variable
  assert_success
}

@test "empty - variable pointing to an empty file" {
  local test_variable=$TMP_FILE;
  run empty $test_variable && assert_failure
}

@test "empty_file - simple variable without value" {
  local test_variable;
  run empty_file $test_variable && assert_failure
}

@test "empty_file - simple variable with not path value" {
  local test_variable="test value";
  run empty_file $test_variable && assert_failure
}

@test "empty_file - not declared variable" {
  run empty_file $test_variable && assert_failure
}

@test "empty_file - empty string" {
  test_variable="";
  run empty_file $test_variable && assert_failure
}

@test "empty_file - variable pointing to an empty file" {
  test_variable=$TMP_FILE;
  run empty_file $test_variable && assert_success
}

@test "empty_variable - variable pointing to a file with content" {
  test_variable=$TMP_FILE;
  echo "this file has content" >> $TMP_FILE
  run empty_file $test_variable && assert_failure
}
