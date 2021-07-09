# frozen_string_literal: true
#vim: sw=2 ts=2 sts=2:

require 'yaml/store'

module CIDB
  module Data
    def self.fetch(key, *args)
      parts = parse_key key
      store_key = parts[1..-1].join('.')
      st = store(parts[0])
      v = st&.transaction do
        st[store_key]
      end
      if v.nil?
        return args[0] unless args.empty? # default
        raise Error.new "Data key #{key.inspect} not found"
      end
      v
    end

    def self.put(key, val)
      parts = parse_key key
      store_key = parts[1..-1].join('.')
      st = store(parts[0], create: true)
      st.transaction do
        st[store_key] = val
      end
    end

    private

    def self.parse_key(key)
      parts = key.split '.'
      if parts.size < 2
        raise Error.new "Data key #{key.inspect} too short"
      end
      parts
    end

    def self.store( name, create: false )
      data_dir = ENV.fetch 'CIDB_DATA', '.'
      fname = File.join data_dir, "#{name}.yaml"
      return unless File.exists?(fname) || create
      YAML::Store.new fname
    end
  end #Data
end #CIDB
