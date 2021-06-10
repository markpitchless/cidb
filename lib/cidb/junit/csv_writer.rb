# frozen_string_literal: true
#vim: sw=2 ts=2 sts=2:

require 'csv'

module CIDB
  module JUnit
    class CSVWriter
      def initialize(
        suite_file: 'suites.csv',
        case_file:  'cases.csv',
        append:     false
      )
        mode = append ? 'a' : 'w'
        @suite_csv = CSV.open suite_file, mode
        @case_csv  = CSV.open case_file, mode
        unless append
          @suite_csv << %w[name timestamp tests failures errors time]
          @case_csv  << %w[classname name time skipped failed]
        end
      end

      def start_suite(suite)
      end

      def end_suite(s)
        @suite_csv << [s.name, s.timestamp, s.tests, s.failures, s.errors, s.time]
      end

      def on_case(c)
        @case_csv << [c.classname, c.name, c.time, c.skipped, c.failed]
      end
    end
  end #JUnit
end #CIDB
