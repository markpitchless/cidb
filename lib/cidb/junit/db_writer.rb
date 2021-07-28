# frozen_string_literal: true
#vim: sw=2 ts=2 sts=2:

module CIDB
  module JUnit
    ##
    # JUnit handler to write suites and cases to the database.
    #
    # Fills the test_suites and test_cases tables. If rows already exist the new
    # insert is skipped. Re-running does not produce duplicates.
    class DBWriter
      include Logging

      def initialize(id)
        @build_id = id
        @current_suite = nil
        @counts = Hash.new(0)
      end

      def inc(key)
        @counts[key.to_sym] += 1
      end

      def count(key)
        @counts[key.to_sym]
      end

      def end_parse(_parser)
        info "Loaded %i test suites and %i test cases into database" % [
          count(:test_suites), count(:test_cases) ]
      end

      def start_suite(suite)
        @current_suite = suite
      end

      def end_suite(s)
        row = s.to_row
        row[:build_id] = @build_id.to_s
        CIDB::DB[:test_suites].insert_conflict.insert(row)
        inc :test_suites

        @current_suite = nil
      end

      def on_case(c)
        row = c.to_row
        row[:build_id] = @build_id.to_s
        CIDB::DB[:test_cases].insert_conflict.insert(row)
        inc :test_cases
      end
    end
  end #JUnit
end #CIDB
