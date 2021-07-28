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
      # TODO: start and finish events, keep count and log inserts done

      def initialize(id)
        @build_id = id
        @current_suite = nil
      end

      def start_suite(suite)
        @current_suite = suite
      end

      def end_suite(s)
        row = s.to_row
        row[:build_id] = @build_id.to_s
        CIDB::DB[:test_suites].insert_conflict.insert(row)

        @current_suite = nil
      end

      def on_case(c)
        row = c.to_row
        row[:build_id]   = @build_id.to_s
        row[:suite_name] = @current_suite&.name.to_s
        CIDB::DB[:test_cases].insert_conflict.insert(row)
      end
    end
  end #JUnit
end #CIDB
