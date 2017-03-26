#!/bin/bash

load test_helper/helper

@test "equals - true comparison" {
  run equals "if equals" "if equals"
  assert_success
}

@test "equals - false comparison" {
  run equals "if equals" "not equals"
  assert_failure
}

@test "equals - without second argument" {
  run equals "testing if equals"
  assert_failure
}

@test "equals - without both argument" {
 run equals
 assert_success "Two variables not initialized or empty are equals."
}
