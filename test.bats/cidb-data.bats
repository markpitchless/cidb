#!/usr/bin/env bats

load bats_helper

export CIDB_DATA="$BATS_RUN_TMPDIR"

@test "cidb-data: --put data" {
  cidb data --put tests.hello world
}

@test "cidb-data: Get data" {
  run cidb data tests.hello
  [ "$status" -eq 0 ]
  [ "$output" == "world" ]
}
