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
      include Counting

      def initialize(id)
        @build_id = id
      end

      def end_parse(parser)
        info "DB: Loaded %i test suites (of %i found)" % [counted(:test_suites), parser.counted(:suites)]
        info "DB: Loaded %i test cases (of %i found)" % [counted(:test_cases), parser.counted(:cases)]
      end

      def end_suite(s)
        row = s.to_row
        row[:build_id] = @build_id.to_s
        CIDB::DB[:test_suites].insert_conflict.insert(row)
        inc :test_suites
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
