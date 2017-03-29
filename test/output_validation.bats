#!/bin/bash

load test_helper/helper

@test "output - empty validation" {
  run empty_output cat empty_file
  assert_success
}

@test "output - empty string validation " {
  #empty string is not an empty output
  run empty_output echo
  assert_failure
}

@test "output - not empty validation" {
  run empty_output echo "content"
  assert_failure
}
