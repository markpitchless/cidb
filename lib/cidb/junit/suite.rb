# frozen_string_literal: true
#vim: sw=2 ts=2 sts=2:

module CIDB
  module JUnit
    class TestSuite
      attr_accessor :name, :errors, :tests, :failures, :time, :timestamp
      attr_accessor :properties
      attr_reader   :case_count

      def initialize
        @case_count = 0
        @properties = Hash.new ""
      end

      def to_s
        "<JUnit::TestSuite #{name.to_s.inspect} #{timestamp} #{tests}ok, #{failures}fails, #{errors}bad in #{time}s>"
      end

      def to_row
        {
          name:      name.to_s,
          timestamp: timestamp,
          tests:     tests.to_i,
          failures:  failures.to_i,
          errors:    errors.to_i,
          time:      time.to_i
        }
      end

      def inc_cases
        @case_count = @case_count + 1
      end

      def timestamp
        return nil if ! @timestamp || @timestamp&.empty?
        @timestamp
      end
    end
  end #JUnit
end #CIDB
