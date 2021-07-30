# frozen_string_literal: true

require "test_helper"

module CIDB
  # Test the CIDB::Counting mixin
  class CountingTest < Test::Unit::TestCase
    include Counting

    test "Counters start at zero" do
      assert_equal counted(:not_counted_yet), 0, 'hello'
    end

    test "increment" do
      increment :hello_inc
      inc :hello_inc
      assert_equal counted(:hello_inc), 2
    end

    test "decrement" do
      decrement :hello_dec
      dec :hello_dec
      assert_equal counted(:hello_dec), -2
    end

    test "inc and dec" do
      inc :fizzle
      inc :fizzle
      inc :fizzle
      dec :fizzle
      dec :fizzle
      assert_equal counted(:fizzle), 1
    end

    test "keys to sym" do
      increment :inc_syms
      inc "inc_syms"
      assert_equal counted(:inc_syms), 2
      assert_equal counted('inc_syms'), 2
    end

    test "counted" do
      inc :apples
      inc 'oranges', amt: 2
      inc :pears

      assert_equal counted(:apples), 1
      assert_equal counted(:oranges), 2
      assert_equal counted(:apples, :oranges), [1, 2]
      assert_equal counted_h(), { apples: 1, oranges: 2, pears: 1 }
      assert_equal counted_h(:oranges), { oranges: 2 }
      assert_equal counted_h(:apples, :oranges), { apples: 1, oranges: 2 }
    end

    test "reset_counts no args - reset all" do
      inc :apples
      assert_equal counted(:apples), 1
      reset_counts
      assert_equal counted(:apples), 0
    end

    test "reset_counts with args" do
      inc :foo
      inc :bar
      inc :baz
      assert_equal counted(:foo, :bar, :baz), [1,1,1]
      reset_counts :foo
      assert_equal counted(:foo, :bar, :baz), [0,1,1]
      inc :foo
      reset_counts :bar, :baz
      assert_equal counted(:foo, :bar, :baz), [1,0,0]
    end
  end
end
