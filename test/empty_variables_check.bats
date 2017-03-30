#!/bin/bash

load test_helper/helper

TMP_FILE="empty_variable_tmp"

function setup(){
  touch $TMP_FILE
}

function teardown(){
  [ ! -f $TMP_FILE ] || rm $TMP_FILE
}

@test "empty_variable - simple variable without value" {
  local test_variable;
  run empty $test_variable
  assert_success
}
@test "empty_variable - simple variable with value" {
  test_variable="test value";
  run empty $test_variable
  assert_failure
}

@test "empty_variable - not declared variable" {
  run empty $test_variable
  assert_success
}

@test "empty_variable - empty string" {
  test_variable="";
  run empty $test_variable
  assert_success
}

@test "empty_variable - variable pointing to an empty file" {
  test_variable=$TMP_FILE;
  run empty $test_variable
  assert_success
}

@test "empty_variable - variable pointing to a file with content" {
  test_variable=$TMP_FILE;
  echo "this file has content" >> $TMP_FILE
  run empty $test_variable
  assert_failure
}
