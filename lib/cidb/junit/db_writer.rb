# frozen_string_literal: true
#vim: sw=2 ts=2 sts=2:

module CIDB
  module JUnit
    class DBWriter
      def initialize(id)
        @build_id = id
      end

      def start_suite(suite)
      end

      def end_suite(s)
        CIDB::DB[:test_suites].insert({
          build_id: @build_id.to_s,
          name: s.name.to_s,
          timestamp: s.timestamp,
          tests: s.tests.to_i, 
          failures: s.failures.to_i,
          errors: s.errors.to_i,
          time: s.time.to_i
        })
      end

      def on_case(c)
        CIDB::DB[:test_cases].insert ({
          build_id: @build_id,
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
