#!/bin/bash

load test_helper/helper

@test "flags - set new flag" {
  set_flag foca
  run flag foca
  assert_success
}

@test "flags - set empty flag" {
  run set_flag
  assert_failure $FLAG_ERROR
}

@test "flags - retrieve flag that don't exist" {
  set_flag test2
  run flag foca
  assert_failure
}

@test "flags - set flag twice" {
  set_flag foca
  set_flag foca
  run flag foca
  assert_success
}

@test "flags - set any value different from 'true' and 'false'" {
  set_flag foca "test_value"
  run flag foca
  assert_failure
}

@test "flags - unset flag" {
  set_flag foca
  run flag foca && assert_success
  unset_flag foca
  run flag foca && assert_failure
}

@test "flags - unset inexistent flag" {
  run unset_flag foca
  assert_success
}
