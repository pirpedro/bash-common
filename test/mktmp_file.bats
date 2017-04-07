#!/usr/bin/env bash

load test_helper/helper

setup(){
  [ -d ~/tmp ] || mkdir ~/tmp
  rm -rf ~/tmp/*
}

@test "mktemp_file - create new tmpfile" {
  run mktmp_file
  [ -e "$output" ]
}
