# frozen_string_literal: true
#vim: sw=2 ts=2 sts=2:

require 'cidb'
require 'sequel'

module CIDB
  DB = Sequel.connect ENV['CIDB_DATABASE_URL']

  class Database
    def connect()
      url = ENV['CIDB_DATABASE_URL']
      @@db = Sequel.connect url
      self.class.const_set :DB, Sequel.connect(url)
    end

    def db
      # TODO: safe wrap over DB, throws NotConnected
      @@db
    end

    # Delegate methods to the Sequel Database
    def method_missing(method, *args)
      return @@db.send(method, *args) if @@db.respond_to?(method)
      super
    end
  end
  # DB = Database.new
end #CIDB
