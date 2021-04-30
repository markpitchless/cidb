# frozen_string_literal: true

require 'stringio'
require 'ox'

module CIDB
  module JUnit

    class JenkinsSax < ::Ox::Sax
      attr_reader :counts

      def initialize(handler)
        @tag_name = ""   # last seen tag name, to use when extracting text
        @suite    = nil  # Set to current TestSuite when inside <suite>
        @case     = nil  # Set to current TestCase when inside <case>

        @handler = handler
        @counts  = Hash.new(0)
      end

      def inc(name, amt = 1)
        @counts[name] = @counts[name] + amt
      end

      def start_element(name)
        @tag_name = name

        case name
        when :suite
          inc :suites
          @suite = { size: 0 }
          @case  = nil
        when :cases # parsed all the suite stuff, cases now
          @handler.start_suite @suite 
        when :case
          inc :cases
          @suite[:size] += 1
          @case = {}
        end
      end

      def end_element(name)
        case name
        when :suite
          @handler.end_suite(@suite) if @suite
          @suite = nil
        when :case
          @handler.on_case(@case) if @case
          @case = nil
        end
      end

      def text(value)
        obj = @case || @suite || return
        meth = @tag_name.downcase
        meth = :time if meth == :duration
        meth = :name if meth == :testname
        obj[meth] = value
      end
    end #Sax

  end #JUnit
end #CIDB

#vim: ts=2 sw=2 sts=2: