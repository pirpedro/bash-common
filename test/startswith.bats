#!/bin/bash

load test_helper/helper

@test "startswith - true comparison" {
  run startswith "testing if starts with" "testing if"
  assert_success
}

@test "startswith - false comparison" {
  run startswith "testing if starts with" "not testing"
  assert_failure
}

@test "startswith - without second argument" {
  run startswith "testing if starts with"
  assert_failure
}

@test "startswith - without both argument" {
 run startswith
 assert_failure
}
