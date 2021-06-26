# frozen_string_literal: true
#vim: ts=2 sw=2 sts=2:

require_relative "cidb/version"
require_relative "cidb/data"
require_relative "cidb/logging"
require_relative "cidb/sloppy"
require_relative "cidb/junit/suite"
require_relative "cidb/junit/case"
require_relative "cidb/junit/sax"
require_relative "cidb/junit/jenkins_sax"
require_relative "cidb/junit/csv_writer"

module CIDB
  class Error < StandardError; end
end
