#!/usr/bin/env ruby
#vim: sw=2 ts=2 sts=2:

require 'logger'
require 'slop' # option parsing

module CIDB
  # Mixin for classes that act as command lines
  module Sloppy
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
    def self.included(base) base.extend DSL end

    def prog_name
      @progname ||= File.basename $0
    end

    ##
    # Return the Logger instance, creates a new one (and caches) if we don't
    # already have one. Default logger is STDERR.
    # You can set CIDB_LOG to change. Use: STDOUT, STDERR or a file name.
    # that.
    def logger
      @logger ||= begin
        log_to = ENV.fetch "CIDB_LOG", "STDERR"
        fmt    = ENV.fetch "CIDB_LOG_FORMAT", "%{prog}: %{level} - %{msg}\n"
        if log_to.match?(/^STD[^\s]+$/i)
          log_to = File.const_get log_to.upcase
        end
        log = Logger.new log_to
        log.formatter = proc do |severity, datetime, progname, msg|
          fmt % { level: severity, time: datetime, prog: prog_name, msg: msg }
        end
        log
      end
    end

    ## Log info messages
    def info(msg)
      logger.info msg
    end

    ## Log error messages
    def error(msg)
      logger.error msg
    end

    ## Log error message and exit with the code given
    def fail!(status, msg)
      logger.fatal msg
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

      yield opt if block_given?
    end

    ##
    # Called by run, via Slop.parse (with opt) to run the option parse.
    # You should impliment this in your class to add your options.
    def slop(opt)
      std_slop opt
    end

    ##
    # Run the command.
    # Parse the options, calling slop(opt). Fix up ARGV.
    # Call your main(opt, arg) method (if there). Hook this to write your command.
    # Slop errors (opt parsing errors) will log the fatal and exit 1.
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
