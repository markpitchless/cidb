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
        CIDB::DB[:test_suites].insert_conflict.insert({
          build_id: @build_id.to_s,
          name: s.name.to_s,
          timestamp: s.timestamp,
          tests: s.tests.to_i,
          failures: s.failures.to_i,
          errors: s.errors.to_i,
          time: s.time.to_i
        })
        @current_suite = nil
      end

      def on_case(c)
        CIDB::DB[:test_cases].insert_conflict.insert({
          build_id: @build_id,
          suite_name: @current_suite&.name.to_s,
          classname: c.classname.to_s,
          name: c.name.to_s,
          time: c.time.to_i,
          skipped: c.skipped,
          failed: c.failed
        })
      end
    end
  end #JUnit
end #CIDB
