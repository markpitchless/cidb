# frozen_string_literal: true
#vim: sw=2 ts=2 sts=2:

require 'cidb'

require 'graphlient'

module CIDB
  module QL
    def self.client
      @client||= Graphlient::Client.new(
        ENV['CIDB_GRAPHQL_URL'],
        headers: {
          'Authorization' => ENV['CIDB_GRAPHQL_TOKEN']
        },
        http_options: {
          read_timeout: 20,
          write_timeout: 30
        }
      )
    end

    def self.query(...)
      client.query(...)
    end

    # Getting query source
    # query = Graphlient::Query.new do
    #   mutation do
    #     # insert_builds(objects: [{ build_id: id }]) do
    #     insert_builds(objects: [build]) do
    #       affected_rows
    #     end
    #   end
    # end
    # puts query.to_s
    # CIDB::QL.query query.to_s
  end #QL
end #CIDB
