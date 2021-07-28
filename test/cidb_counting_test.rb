# frozen_string_literal: true

require "test_helper"

module CIDB
  # Test the CIDB::Counting mixin
  class CountingTest < Test::Unit::TestCase
    include Counting

    test "Counters start at zero" do
      assert do
        counted(:not_counted_yet) == 0
      end
    end

    test "increment" do
      increment :hello_inc
      inc :hello_inc
      assert do
        counted(:hello_inc) == 2
      end
    end

    test "decrement" do
      decrement :hello_dec
      dec :hello_dec
      assert do
        counted(:hello_dec) == -2
      end
    end

    test "inc and dec" do
      inc :fizzle
      inc :fizzle
      inc :fizzle
      dec :fizzle
      dec :fizzle
      assert do
        counted(:fizzle) == 1
      end
    end

    test "keys to sym" do
      increment :inc_syms
      inc "inc_syms"
      assert do counted(:inc_syms) == 2 end
      assert do counted('inc_syms') == 2 end
    end

    test "counted" do
      inc :apples
      inc 'oranges', amt: 2
      inc :pears

      assert do counted(:apples) == 1 end
      assert do counted(:oranges) == 2 end

      assert do counted(:apples, :oranges) == [1, 2] end

      assert do counted_h() == { apples: 1, oranges: 2, pears: 1 } end
      assert do counted_h(:oranges) == { oranges: 2 } end
      assert do counted_h(:apples, :oranges) == { apples: 1, oranges: 2 } end
    end

    test "reset_counts" do
      inc :apples
      assert do counted(:apples) == 1 end
      reset_counts
      assert do counted(:apples) == 0 end
    end
  end
end
