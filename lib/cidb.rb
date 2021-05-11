# frozen_string_literal: true

require_relative "cidb/version"
require_relative "cidb/junit/suite"
require_relative "cidb/junit/case"
require_relative "cidb/junit/sax"
require_relative "cidb/junit/jenkins_sax"
require_relative "cidb/junit/csv_writer"

module CIDB
  class Error < StandardError; end
end

#vim: ts=2 sw=2 sts=2:
