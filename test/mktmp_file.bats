#!/usr/bin/env bash

load test_helper/helper

setup(){
  [ -d ~/tmp ] || mkdir ~/tmp
  rm -rf ~/tmp/*
}

@test "mktemp_file - create new tmpfile" {
  file=$(mktmp_file)
  [[ -e "$file" ]]
}

@test "mktemp_file - test clean_up function" {
  run mktmp_file
  clean_up
  [[ ! -e "$output" ]] #output contains path to the created tmp file.
}
