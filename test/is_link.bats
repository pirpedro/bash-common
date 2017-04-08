#!/usr/bin/env bash

load test_helper/helper

setup(){
  [ ! -d ~/tmp ] || rm -rf ~/tmp
  mkdir ~/tmp
}

@test "is_link - no argument passed to function." {
  run is_link && assert_failure
}

@test "is_link - regular file check" {
  file=$(mktmp_file)
  run is_link "$file" && assert_failure
}

@test "is_link - symbolic link check" {
  file=$(mktmp_file)
  link="$HOME/tmp/mylink$(random)"
  ln -s "$file" "$link"
  run is_link "$file" && assert_failure
  run is_link "$link" && assert_success

}

@test "is_link - dot regular file check" {
  file="$HOME/tmp/.myfile$(random)"
  touch "$file"
  run is_link "$file" && assert_failure
}

@test "is_link - dot symbolic link check" {
  file=$(mktmp_file)
  link="$HOME/tmp/.mylink$(random)"
  ln -s "$file" "$link"
  run is_link "${link}" && assert_success
  run is_link "$file" && assert_failure
}

@test "is_link - regular directory" {
  dir="$HOME/tmp/$(random)"
  mkdir -p "$dir"
  run is_link "$dir" && assert_failure
}

@test "is_link - link directory" {
  dir="$HOME/tmp/$(random)"
  mkdir -p "$dir"
  link="$HOME/tmp/mylink$(random)"
  ln -s "$dir" "$link"
  run is_link "$link" && assert_success
  run is_link "$dir" && assert_failure
}

@test "is_link - dot directory" {
  dir="$HOME/tmp/.$(random)"
  mkdir -p "$dir"
  run is_link "$dir" && assert_failure
}

@test "is_link - dot link directory" {
  dir="$HOME/tmp/$(random)"
  mkdir -p "$dir"
  link="$HOME/tmp/.mylink$(random)"
  ln -s "$dir" "$link"
  run is_link "$link" && assert_success
  run is_link "$dir" && assert_failure
}
