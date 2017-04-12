#!/usr/bin/env bash

load test_helper/helper

@test "to_alternatives - no argument passed" {
  run to_alternatives  && assert_success
  assert_output ""
}

@test "to_alternatives - pass single element" {
  run to_alternatives "element" && assert_success
  assert_output "element"
}

@test "to_alternatives - pass multiple elements" {
  run to_alternatives "element1 element2 element3" && assert_success
  assert_output "element1|element2|element3"
}

@test "__to_extglob" {
  run __to_extglob "element1 element2 element3" "@" && assert_success
  assert_output "@(element1|element2|element3)"
}

@test "case_one - use in case block" {
  assert_failure
}
