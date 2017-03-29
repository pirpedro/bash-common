#!/bin/bash

load test_helper/helper

@test "verbose - logging without verbosity mode" {
  msg="verbosity working"
  run log $msg
  assert_output ""
}

@test "verbose - logging with verbosity mode" {
  msg="verbosity working"
  verbosity on
  run flag verbosity && assert_success
  run log $msg
  assert_output $msg
}

@test "verbose - using flag force" {
  msg="verbosity working"
  run log -f $msg
  assert_output $msg
}
