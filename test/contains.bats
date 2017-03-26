#!/bin/bash

load test_helper/helper

@test "contains - true comparison" {
  run contains "if contains some string inside" "ome string" 
  assert_success
}

@test "contains - false comparison" {
  run contains "if contains some string inside" "somes string"
  assert_failure
}

@test "contains - without second argument" {
  run contains "testing if contains"
  assert_failure
}

@test "contains - without both argument" {
 run contains
 assert_failure
}
