# frozen_string_literal: true

require "test_helper"

class CIDBTest < Test::Unit::TestCase
  test "VERSION" do
    refute_nil ::CIDB::VERSION
  end
end
