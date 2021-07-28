# frozen_string_literal: true
#vim: sw=2 ts=2 sts=2:

require 'stringio'
require 'ox'

module CIDB
  module JUnit
    class TestCaseFailure
      attr_accessor :message, :type, :text
    end

    class TestCase
      attr_accessor :classname, :name, :time, :skipped, :failed
      attr_reader   :failure

      def initialize
        @classname = ""
        @name      = ""
        @time      = nil
        @skipped   = false
        @failed    = false
        @failure   = TestCaseFailure.new
      end

      def to_s
        "<JUnit::TestCase #{classname.to_s.inspect} #{name.to_s.inspect} #{ok? ? 'Ok' : fail? ? 'Fail' : 'Skip'} in #{time}s>"
      end

      def to_row
        {
          classname: classname.to_s,
          name:      name.to_s,
          time:      time.to_i,
          skipped:   skipped,
          failed:    failed
        }
      end

      def pass?
        ! @skipped || ! @failed
      end


      def failed?
        @failed
      end

      alias :ok?   :pass?
      alias :fail? :failed?
    end #TestCase

  end #JUnit
end #CIDB

#vim: ts=2 sw=2 sts=2:
