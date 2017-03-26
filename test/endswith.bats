#!/bin/bash

load test_helper/helper

@test "endswith - true comparison" {
  run endswith "testing if ends with" "ends with"
  assert_success
}

@test "endswith - false comparison" {
  run endswith "testing if ends with" "not ends with"
  assert_failure
}

@test "endswith - without second argument" {
  run endswith "testing if ends with"
  assert_failure
}

@test "endswith - without both argument" {
 run endswith
 assert_failure
}
