#!/usr/bin/env bash

##execute script for sintaxe test.
$TRAVIS_BUILD_DIR/sh-common

if [[ $TRAVIS_BRANCH == 'test_suite' ]]; then
  cd $TRAVIS_BUILD_DIR/test/ && bats .
fi
