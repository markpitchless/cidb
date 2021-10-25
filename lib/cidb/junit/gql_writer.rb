# frozen_string_literal: true
#vim: sw=2 ts=2 sts=2:

require 'cidb/ql'

module CIDB
  module JUnit
    ##
    # JUnit handler to write suites and cases to the graphql api.
    #
    # If data already exists, it is updated with the incoming values. Re-run are
    # safe and do not produce duplicates.
    class GQLWriter
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
        @suites_query ||= CIDB::QL.client.parse <<~GRAPHQL
          mutation ($objects: [test_suites_insert_input!] = []) {
            insert_test_suites(objects: $objects, on_conflict: {constraint: test_suites_pkey, update_columns: [errors, failures, tests, time, timestamp]}) {
              affected_rows
            }
        }
        GRAPHQL
        CIDB::QL.client.execute( @suites_query, { objects: [row] } )
        inc :test_suites
      end

      def on_case(c)
        row = c.to_row
        row[:build_id] = @build_id.to_s
        @cases_query ||= CIDB::QL.client.parse <<~GRAPHQL
          mutation ($objects: [test_cases_insert_input!] = []) {
            insert_test_cases(objects: $objects, on_conflict: {constraint: test_cases_pkey, update_columns: [time, skipped, failed]}) {
              affected_rows
            }
        }
        GRAPHQL
        CIDB::QL.client.execute( @cases_query, { objects: [row] } )
        inc :test_cases
      end
    end
  end #JUnit
end #CIDB
