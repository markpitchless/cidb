#!/usr/bin/env ruby
#vim: sw=2 ts=2 sts=2:

require 'logger'

module CIDB
  ##
  # Mixin to add logging methods.
  module Logging
    ##
    # Return the Logger instance, creates a new one (and caches) if we don't
    # already have one. Default logger is STDERR.
    # You can set CIDB_LOG to change. Use: STDOUT, STDERR or a file name.
    def logger
      @logger ||= begin
        log_to = ENV.fetch "CIDB_LOG", "STDERR"
        # TODO: Support log file aging and rotation. e.g. "foo.log:daily" "foo.log:10,1024000"
        fmt    = ENV.fetch "CIDB_LOG_FORMAT", "%{prog}: %{level}: %{msg}\n"
        level  = ENV.fetch "CIDB_LOG_LEVEL", "INFO"
        if log_to.match?(/^STD[^\s]+$/i)
          log_to = File.const_get log_to.upcase
        end
        log = Logger.new log_to, level: level
        log.formatter = proc do |severity, datetime, progname, msg|
          fmt % { level: severity.downcase, time: datetime, prog: prog_name, msg: msg }
        end
        log
      end
    end

    def prog_name
      @progname ||= File.basename $0
    end

    ## Log info messages
    def info(msg)
      logger.info msg
    end

    ## Log error messages
    def error(msg)
      logger.error msg
    end

    ##
    # Log fatal message and raise CIDB::FatalError with the message.
    #
    # The FatalError raised will be caught at the edge of the `cicd` commands,
    # which will then fail (non-zero status) gracefully. The log message you
    # give is likley what the user (or later log spelunker) will see. Try iand
    # include details of what the can do to resolve the situation. e.g. what env
    # var to set or options to pass.
    def fatal!(msg)
      logger.fatal msg
      raise CIDB::FatalError, msg, caller
    end

    ## DEPRECATED: old fatal logging that doesn't throw
    def fatal(msg)
      logger.fatal msg
    end

  end #Logging
end #CIDB
