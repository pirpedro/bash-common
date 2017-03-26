#!/bin/bash

load test_helper/helper

@test "check_boolean - true comparison 1" {
  run check_boolean "Yes"
  assert_success
}

@test "check_boolean - true comparison 2" {
  run check_boolean "y"
  assert_success
}

@test "check_boolean - true comparison 3" {
  run check_boolean 0
  assert_success
}

@test "check_boolean - true comparison 4" {
  run check_boolean "on"
  assert_success
}

@test "check_boolean - false comparison 1" {
  run check_boolean "no"
  assert_failure
}

@test "check_boolean - false comparison 2" {
  run check_boolean "N"
  assert_failure
}

@test "check_boolean - false comparison 3" {
  run check_boolean 1
  assert_failure
}

@test "check_boolean - false comparison 4" {
  run check_boolean "OFF"
  assert_failure
}

@test "check_boolean - other string as argument" {
  run check_boolean "foca"
  assert_failure 2
}

@test "check_boolean - no argument" {
  run check_boolean
  assert_failure 2
}
