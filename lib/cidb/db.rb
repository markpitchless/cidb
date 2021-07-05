# frozen_string_literal: true
#vim: sw=2 ts=2 sts=2:

require 'cidb'
require 'sequel'

module CIDB
  DB = Sequel.connect ENV['CIDB_DATABASE_URL']
end #CIDB
