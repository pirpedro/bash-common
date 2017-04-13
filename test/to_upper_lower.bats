#!/bin/bash

load test_helper/helper

@test "to_upper - no arguments" {
  run to_upper && assert_success
  assert_output ""
}

@test "to_upper - with numbers" {
  run to_upper "9mBlC" && assert_success
  assert_output "9MBLC"
}

@test "to_upper - with only upper chars" {
  run to_upper "TEST" && assert_success
  assert_output "TEST"
}

@test "to_lower - no arguments" {
  run to_lower && assert_success
  assert_output ""
}

@test "to_lower - with numbers" {
  run to_lower "9mBlC" && assert_success
  assert_output "9mblc"
}

@test "to_lower - with only lower chars" {
  run to_lower "test" && assert_success
  assert_output "test"
}
