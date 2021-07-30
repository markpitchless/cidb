# frozen_string_literal: true
#vim: ts=2 sw=2 sts=2:

require_relative "cidb/version"
require_relative "cidb/logging"
require_relative "cidb/counting"
require_relative "cidb/data"
require_relative "cidb/sloppy"
require_relative "cidb/junit/suite"
require_relative "cidb/junit/case"
require_relative "cidb/junit/parser"
require_relative "cidb/junit/jenkins_sax"
require_relative "cidb/junit/csv_writer"
require_relative "cidb/junit/db_writer"

module CIDB
  ## General errors raised by CICD. ie application erros rather than internal bugs.
  class Error < StandardError; end

  ##
  # Fatal errors, the situation is so bad we can't go on. Not meant to be
  # normally handled (nothing you can do) but they should be caught at the edge
  # of the application and used to fail gracefully. CICD::Sloppy does this for
  # all the `cicd` commands.
  #
  # Don't throw these directly, instead use CICD::Logging#fatal! to make sure
  # the error gets logged (be kind to your users).
  #
  # Note: explicitly does NOT sub class CIDB::Error, to stop it getting
  # accidentally caught by a rescue CIDB::Error.
  class FatalError < StandardError
    ##
    # Recommended exit status to exit with if rescuing this error in your
    # application. You can use any code you like as long as it is not zero!
    def exitstatus
      23
    end
  end

  def self.connect
    require_relative 'cidb/db'
  end
end
