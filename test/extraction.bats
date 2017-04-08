#!/usr/bin/env bash

load test_helper/helper

setup(){
  [ -d ~/tmp ] || mkdir ~/tmp
  rm -rf ~/tmp/*
  TMP_FILE="$(mktmp_file)"
}

function teardown(){
  [ ! -f "$TMP_FILE" ] || rm "$TMP_FILE"
}

@test "zipf - no arguments" {
  run zipf && assert_failure
}

@test "zipf - not a file" {
  not_a_file="$HOME/tmp/not_a_file"
  run zipf "$not_a_file" && assert_failure
}

@test "zip - regular file" {
  run zipf "$TMP_FILE" && assert_success
  [ -f "$TMP_FILE.zip" ]
}

@test "zip - empty folder" {
  dir="$HOME/tmp/test$(random)"
  mkdir -p "$dir"
  run zipf "$dir" && assert_success
  [ -f "$dir.zip" ]
}

@test "zip - folder with content" {
  dir="$HOME/tmp/test$(random)"
  mkdir -p "$dir"
  touch "$dir/$(random)"
  touch "$dir/$(random)"
  run zipf "$dir" && assert_success
  [ -f "$dir.zip" ]
}

@test "extract - no arguments" {
  run extract && assert_failure
}

@test "extract - not a file" {
  not_a_file="$HOME/tmp/not_a_file"
  run extract "$not_a_file" && assert_failure
  assert_output "'$not_a_file' is not a valid file."
}
