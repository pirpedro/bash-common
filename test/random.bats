#!/bin/bash

load test_helper/helper

@test "random - simple string generator" {
  run random
  for ((i = 0; i < 50; i++)); do
    run random
    assert_equal "${#output}" 8
  done
}

@test "random - defining string length" {
  length=17
  for ((i = 0; i < 50; i++)); do
    run random $length
    assert_equal "${#output}" "$length"
  done
}

@test "random - simple number generator" {
  for ((i = 0; i < 50; i++)); do
    run rng
    if ! [[ "$output" =~ ^[0-9]+$ ]]; then
      assert_failure
    fi
  done
  assert_success
}

@test "random - defining number generator length" {
  length=7
  for ((i = 0; i < 50; i++)); do
    run rng $length
    if ! [[ "$output" =~ ^[0-9]+$ ]]; then
      assert_failure
    fi
  done
  assert_success
}
