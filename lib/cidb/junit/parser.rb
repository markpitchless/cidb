# frozen_string_literal: true
#vim: ts=2 sw=2 sts=2:

require 'stringio'
require 'ox'

module CIDB
  module JUnit
    ##
    # A class for parsing JUnit XML files.
    # 
    # You give the constructor a handler class and the parser will call methods
    # on that handler for junit events, passing objects for cases and suites,
    # with all the fields filled from the XML.
    #
    #   handler = JUnit::CSVWriter.new
    #   File.open 'junit.xml', 'r' do |f|
    #     JUnit::Parser.new(handler).parse(f)
    #   end
    # 
    # Handler gets 3 callbacks called repeatedly:
    #
    #   def start_suite(suite) # Start of suite, before test cases
    #   def end_suite(suite)   # Complete suite and cases
    #   def on_case(tcase)     # Fires once for each complete TestCase
    #
    # * suite is a TestSuite instance
    # * tcase is a TestCase instance
    # * end_suite is generally what you want to hook
    # * XXX: start_suite does NOT fire for empty suites
    #
    # If you want to do some setup or teardown, aggregation etc, there are two
    # hooks that only get called once each for the parse:
    #
    #   def start_parse(parser) # After file open, but before parse
    #   def end_parse(parser)   # After all XML parsing down
    #
    class Parser < ::Ox::Sax
      attr_reader :tag_count, :counts

      def initialize(handler=nil)
        @tag_count   = Hash.new(0) 
        @tag_name    = ""   # last seen tag name, to use when extracting text
        @prop_name   = nil  # last seen name value of <property name=""
        @suite       = nil  # Set to current TestSuite when inside <suite>
        @case        = nil  # Set to current TestCase when inside <case>

        @counts = Hash.new(0)

        @handler = handler
      end

      def parse(io)
        start_parse
        Ox.sax_parse self, io
        end_parse
      end

      def inc(name, amt = 1)
        @counts[name] = @counts[name] + amt
      end

      def start_element(name)
        @tag_name = name
        @tag_count[name] = @tag_count[name] + 1 

        case name
        when :testsuite
          inc :suites
          @suite = TestSuite.new
        when :testcase
          inc :cases
          @suite.inc_cases
          @case = TestCase.new(@suite)
        when :skipped
          @case.skipped = true if @case
        when :failure
          @case.failed = true if @case
        end
      end

      # Offset "starting" the object until we have filled in the attrs!
      def attrs_done();
        case @tag_name 
        when :testsuite
          start_suite @suite
        end
      end

      def end_element(name)
        case name
        when :testsuite
          end_suite @suite
          @suite = nil
        when :testcase
          on_case @case
          @case = nil
        end
      end

      def attr(name, str)
        obj = nil
        case @tag_name
        when :testsuite
          obj = @suite
        when :testcase
          obj = @case
        when :property
          case name
          when :name
            @prop_name = str
          when :value
            if @suite
              @suite.properties[@prop_name] = str
            end
          end
        end
        if obj
          obj.send("#{name}=", str) if obj.respond_to? name
        end
      end

      protected

      # Hooks for sub classers to do stuff with the parsed out data

      # Called at the start, after opening the file, but before any parsing happens.
      def start_parse()
        @handler.start_parse(self) if @handler&.respond_to?(:start_parse)
      end

      # Called once the entire XML parse is complete.
      # Note, currently not guaranteed to be called if the parse throws.
      def end_parse()
        @handler.end_parse(self) if @handler&.respond_to?(:end_parse)
      end

      # Called with a TestSuite instance after reading the suite and it's
      # properties but before seeing and test cases.
      # XXX: Doesn't fire for an empty testsuite.
      def start_suite(suite)
        @handler.start_suite suite
      end

      # Called with a TestSuite instance after processing all of it's test cases.
      # The suite is now complete. Generally what you want to hook.
      def end_suite(suite)
        @handler.end_suite suite if @handler
      end

      # Fires once for each complete TestCase, after fully reading it's data.
      def on_case(tcase)
        @handler.on_case tcase if @handler
      end

    end #Parser
  end #JUnit
end #CIDB
