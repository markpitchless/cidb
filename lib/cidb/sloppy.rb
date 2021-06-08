#!/usr/bin/env ruby
#vim: sw=2 ts=2 sts=2:

require 'slop' # option parsing

module CIDB
  # Mixin for classes that act as command lines
  module Sloppy
    # TODO: 
    # attr :banner
    # def self.banner= DSL that sets up the banner
    # e.g.banner "usage: $0 [OPTIONS] [FILES]"

    # TODO: def description(String|Block) ## Generate a description method

    def prog_name
      @progname ||= File.basename $0
    end

    ## Log info messages to STDERR
    def info(msg)
      STDERR.puts "#{@progname}:  INFO: #{msg}"
    end

    ## Log error messages to STDERR
    def error(msg)
      STDERR.puts "#{@progname}: ERROR: #{msg}"
    end

    ## Log error message and exit with the code given
    def fail!(status, msg)
      STDERR.puts "#{@progname}:  FAIL: #{msg}"
      exit status
    end

    def banner
      "USAGE: #{prog_name} [OPTIONS]"
    end

    # TODO: --quite to stop info logging. Twice for errors. 3 times for --silent
    def std_slop(opt)
      opt.banner = banner if respond_to? :banner
      opt.on '--version', 'Print the version' do
        puts CIDB::VERSION
        exit
      end
      opt.on '--help', 'Print usage message and option docs' do
        puts opt
        exit
      end

      if respond_to? :description
        opt.separator "\nDESCRIPTION:"
        opt.separator "    " + description
      end

      yield(opt) if block_given?
    end

    ##
    # Called by run, via Slop.parse (with opt) to run the option parse.
    # You should impliment this in your class to add your options.
    def slop(opt)
      std_slop opt
    end

    def run
      @opts = Slop.parse { |opt| slop opt }
      @args = @opts.arguments
      ARGV.replace @opts.arguments # Make sure sloptions aren't consumed by ARGF

      main @opts, @arg if respond_to? :main # Dispatch to the including class
    rescue Slop::Error => err
      fail! 1, err
    end

  end #Sloppy
end #CIDB
