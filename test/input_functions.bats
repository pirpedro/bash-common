#!/bin/bash

load test_helper/helper

@test "ask - simple question selecting default value" {
  ask --question="Question?" --options="option1,option2" --default="option2" <<< $'\n'
  assert_equal "option2" ${ask_answer}
}

@test "ask - simple question with input value" {
  ask --question="Question?" --options="option1,option2" --default="option2" <<< $'option1\n'
  assert_equal "option1" ${ask_answer}
}

@test "ask - simple question with wrong value" {
  ask --question="Question?" --options="option1,option2" --default="option2" <<< $'wrongOption\n'
  assert_equal "option2" ${ask_answer}
}

@test "ask - simple question with free answer" {
  ask --question="Question?" --options="option1,option2" --default="option2" --free-answer <<< $'wrongOption\n'
  assert_equal "wrongOption" ${ask_answer}
}

@test "ask - simple question with many options" {
  ask --question="Question?" --options="firstOpt,secondOpt,thirdOpt,nOpt" --default="thirdOpt" <<< $'secondOpt\n'
  assert_equal "secondOpt" ${ask_answer}
}

@test "ask - without question" {
  run ask --options="option1,option2" --default="option2" <<< $'wrongOption\n'
  assert_failure
}

@test "ask - without options" {
  run ask --question="Question?" <<< $'wrongOption\n'
  assert_failure 2
}

@test "ask - without options and using only default" {
  ask --question="Question?" --default="option2" <<< $'\n'
  assert_equal "option2" ${ask_answer}
}

@test "ask - free answer without options" {
  ask --question="Question?" --free-answer <<< $'anything\n'
  assert_equal "anything" ${ask_answer}
}

@test "ask - simple boolean question (answer default)" {
  run ask_boolean "Question?" <<< $'\n'
  assert_success
}

@test "ask - simple boolean question (answer no)" {
  run ask_boolean "Question?" <<< $'no\n'
  assert_failure
}

@test "ask - boolean, default value TRUE" {
  run ask_boolean "Question?" $FLAG_TRUE <<< $'\n'
  assert_success
}

@test "ask - boolean, default value FALSE" {
  run ask_boolean "Question?" $FLAG_FALSE <<< $'\n'
  assert_failure
}

@test "ask - boolean, answering anything else" {
  run ask_boolean "Question?" <<< $'wrongOption\n'
  assert_success
}
