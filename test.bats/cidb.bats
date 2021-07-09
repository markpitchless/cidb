#!/usr/bin/env bats

load bats_helper

@test "Displays help with no args" {
  run cidb
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == 'USAGE:' ]
  [ "${lines[1]}" == '  cidb [OPTIONS]' ]
}

@test "Dispatch to scan --help" {
  run cidb scan --help
  [ "$status" -eq 0 ]
  [ "${lines[1]}" == '  cidb-scan [OPTIONS] [PATH]' ]
}

# @test "Can scan for its own repo" {
#   gh-repo-scan ls | grep github-scanner
# }
