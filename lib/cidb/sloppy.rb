#!/usr/bin/env ruby
#vim: sw=2 ts=2 sts=2:

require 'logger'
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
        # TODO: Support log file aging and rotation. e.g. "foo.log:daily" "foo.log:10,1024000"
        fmt    = ENV.fetch "CIDB_LOG_FORMAT", "%{prog}: %{level} - %{msg}\n"
        level  = ENV.fetch "CIDB_LOG_LEVEL", "INFO"
        if log_to.match?(/^STD[^\s]+$/i)
          log_to = File.const_get log_to.upcase
        end
        log = Logger.new log_to, level: level
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
    rescue Slop::Error => err
      fail! 1, err
    end

  end #Sloppy
end #CIDB
