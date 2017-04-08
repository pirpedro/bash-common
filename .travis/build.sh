#!/usr/bin/env bash

##execute script for sintaxe test.
$TRAVIS_BUILD_DIR/bin/sh-common
#if [[ $TRAVIS_BRANCH == 'test_suite' ]]; then
chmod +x $TRAVIS_BUILD_DIR/test/run_tests.sh
$TRAVIS_BUILD_DIR/test/run_tests.sh
#fi
