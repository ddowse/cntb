#!/usr/bin/env bats

load handling_conf_files.bash
load globals.bash
load_lib bats-support
load_lib bats-assert

function setup_file() {
    store_config_files
    ensureTestConfig
}

function teardown_file() {
    restore_config_files
}

###
### arugments
###

@test 'reset password : ok : invalid user id : nok' {
  run ./cntb resetPassword user "$USER_ID"
  assert_success

  run ./cntb resetPassword user 32163657126573126535612
  assert_failure

}

@test 'wrong user id  : nok' {
  run ./cntb resetPassword user 78953218-1ba4-4b9b-ae32-1c5ebf037ac0
  assert_failure
}
