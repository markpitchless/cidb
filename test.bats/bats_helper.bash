#!/usr/bin/env bash

export GITHUB_ORG=fac

# Hide use of bundler from the tests
cidb() {
  bundle exec bin/cidb "$@"
}
