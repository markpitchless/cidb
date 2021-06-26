# frozen_string_literal: true
#vim: sw=2 ts=2 sts=2:

require 'cidb'
require 'yaml/store'

module CIDB
  module Data
    def self.get_data(key)
      parts = key.split '.'
      if parts.size < 2
        raise Error.new "Data key #{key.inspect} too short"
      end
      st = store(parts[0])
      store_key = parts[1..-1].join('.')
      v = st.transaction do st[store_key] end
      raise Error.new "Data key #{key.inspect} not found" if v.nil?
      v
    end

    def self.put_data(key, val)
      parts = key.split '.'
      if parts.size < 2
        raise Error.new "Data key #{key.inspect} too short"
      end
      st = store(parts[0])
      store_key = parts[1..-1].join('.')
      st.transaction do st[store_key] = val end
    end

    def self.store(name)
      fname = "%s.yaml" % name
      raise Error.new "Data store #{fname.inspect} not found" unless File.exists? fname
      YAML::Store.new fname
    end
  end #Data
end #CIDB