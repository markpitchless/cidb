#!/usr/bin/env ruby
#vim: sw=2 ts=2 sts=2:

require 'cidb/logging'
require 'slop' # option parsing

module CIDB
  ##
  # Mixin for classes that act as slop driven command lines
  #
  #  class GreetCommand
  #    include CIDB::Sloppy
  #
  #    banner "USAGE: %{prog} [OPTIONS] FILE"
  #    description <<~EOT
  #      Process foo files
  #    EOT
  #
  #    def slop(opt)
  #      opt.bool "--bye"
  #    end
  #
  #    def main(opts, args)
  #      greeting == if opts.bye? then "goodbye" else "hello" end
  #      puts "#{greeting} #{args.join(', ')}"
  #    end
  #  end
  module Sloppy
    include CIDB::Logging

    module DSL
      def banner(desc=nil)
        if block_given?
          define_method :banner, block
        else
          define_method :banner do
            desc.to_s % { prog: prog_name }
          end
        end
      end

      def description(desc=nil)
        if block_given?
          define_method :description, block
        else
          define_method :description do desc.to_s end
        end
      end
    end
    def self.included(base)
      base.extend DSL
    end

    def banner
      "USAGE: #{prog_name} [OPTIONS]"
    end

    # TODO: --quite to stop info logging. Twice for errors. 3 times for --silent
    def std_slop(opt=nil)
      opt.banner = banner if respond_to? :banner

      opt.on '--version', 'Print the version' do
        puts CIDB::VERSION
        exit
      end
      opt.on '--help', 'Print usage message and option docs' do
        puts opt
        exit
      end

      if block_given?
        opt.separator ""
        yield opt
      end

      if respond_to? :description
        opt.separator "\nDESCRIPTION:"
        opt.separator "    " + description
      end
    end

    def slop(o)
    end

    ##
    # Run the command.
    # Parse the options, calling slop(opt). Fix up ARGV.
    # Call your main(opt, args) method (if there). Hook this to write your command.
    # Slop errors (opt parsing errors) will log the fatal and exit 1.
    def run
      @opts = Slop.parse do |opt| std_slop(opt) { |o| slop(o) } end
      @args = @opts.arguments
      ARGV.replace @opts.arguments # Make sure sloptions aren't consumed by ARGF
      main @opts, @args if respond_to? :main # Dispatch to the including class
    rescue CIDB::FatalError => err
      exit err.exitstatus # hopefully raised with fatal! so logged
    rescue Slop::Error => err # opt parsing error
      error err
      exit 2
    rescue CIDB::Error => err
      error err
      exit 10
    end

  end #Sloppy
end #CIDB
