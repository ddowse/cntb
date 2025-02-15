#!/usr/bin/env bats

load handling_conf_files.bash
load globals.bash
load_lib bats-support
load_lib bats-assert

function setup_file() {
  store_config_files
  ensureTestConfig
  deleteCache
}

function teardown_file() {
  restore_config_files
}

@test "get snapshots: ok" {
  run ./cntb create snapshot ${INSTANCE_ID} --name="snapshot${TEST_SUFFIX}" --description='test snapshot'
  assert_success
  snapshotId="$output"

  run ./cntb get snapshots ${INSTANCE_ID}
  assert_success
  assert_output --partial 'SNAPSHOTID'
  assert_output --partial 'NAME'
  assert_output --partial 'DESCRIPTION'
  assert_output --partial 'CREATEDDATE'

  run ./cntb get snapshots ${INSTANCE_ID} -o wide
  assert_success
  assert_output --partial 'SNAPSHOTID'
  assert_output --partial 'NAME'
  assert_output --partial 'DESCRIPTION'
  assert_output --partial 'CREATEDDATE'
  assert_output --partial 'CUSTOMERID'
  assert_output --partial 'TENANTID'

  run ./cntb get snapshots ${INSTANCE_ID} -o json
  assert_success
  assert_output --partial '"snapshotId"'
  assert_output --partial '"name"'
  assert_output --partial '"description"'
  assert_output --partial '"createdDate"'
  assert_output --partial '"customerId"'
  assert_output --partial '"tenantId"'

  run ./cntb get snapshots ${INSTANCE_ID} -o yaml
  assert_success
  assert_output --partial 'snapshotId:'
  assert_output --partial 'name:'
  assert_output --partial 'description:'
  assert_output --partial 'createdDate:'
  assert_output --partial 'customerId:'
  assert_output --partial 'tenantId:'

  run ./cntb get snapshots ${INSTANCE_ID} --name "snapshot${TEST_SUFFIX}"
  assert_success
  assert_output --partial 'SNAPSHOTID'
  assert_output --partial 'NAME'
  assert_output --partial 'DESCRIPTION'
  assert_output --partial 'CREATEDDATE'
  assert_output --partial "snapshot${TEST_SUFFIX}"
  assert_output --partial "$snapshotId"

  # clean up
  run ./cntb delete snapshot ${INSTANCE_ID} "$snapshotId"
  assert_success
}

@test "get snapshots with invalid instanceId: nok" {
  run ./cntb get snapshots aa
  assert_failure
}

@test "get snapshots without inputs: nok" {
  run ./cntb get snapshots
  assert_failure
}

@test "get snapshots with wrong number of inputs: nok" {
  run .run ./cntb get snapshots a b c
  assert_failure
}