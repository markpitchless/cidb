# frozen_string_literal: true
#vim: sw=2 ts=2 sts=2:

require 'csv'

module CIDB
  module JUnit
    ##
    # CIDB::JUnit handler to write suites and cases CSV files.
    #
    # By default will overwrite existing files with new data. Set append:true on
    # construction to have it append to existing files (if found).
    class CSVWriter
      include Logging

      attr_accessor :suite_file, :case_file, :append

      def initialize(
        suite_file: 'suites.csv',
        case_file:  'cases.csv',
        append:     false
      )
        @append = append
        @suite_file = suite_file
        @case_file  = case_file
      end

      def start_suite(suite)
        unless @suite_csv
          @suite_csv = CSV.open suite_file, (append ? 'a' : 'w')
          @suite_csv << suite.to_row.keys unless append
          info (append ? 'Appending to' : 'Opening new') + " CSV file: #{suite_file}"
        end
      end

      def end_suite(s)
        @suite_csv << s.to_row.values
      end

      def on_case(c)
        unless @case_csv
          @case_csv = CSV.open case_file, (append ? 'a' : 'w')
          @case_csv << c.to_row.keys unless append
        end
        @case_csv << c.to_row.values
      end
    end
  end #JUnit
end #CIDB
