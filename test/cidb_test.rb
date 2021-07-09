# frozen_string_literal: true

require "test_helper"

class CIDBTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::CIDB.const_defined?(:VERSION)
    end
  end
end
