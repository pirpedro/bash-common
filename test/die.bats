#!/bin/bash

load test_helper/helper

@test "die - check exit function with message" {
  msg="exit message"
  run die $msg
  assert_failure
  assert_output $msg
}

@test "die - check exit function without message" {
  run die
  assert_failure
  assert_output ""
}

@test "die - with specific status" {
  msg="exit message"
  run die_with_status 2 $msg
  assert_failure 2
  assert_output $msg
}
