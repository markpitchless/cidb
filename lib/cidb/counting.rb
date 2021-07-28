#!/usr/bin/env ruby
#vim: sw=2 ts=2 sts=2:

module CIDB
  ##
  # Mixin to add methods to count things.
  #
  # It is pretty common for classes doing scanning, importy type things to need
  # to keep counts of things, items parsed, number skipped etc. Just import
  # Counting, call inc to count and counted to get the count.
  #
  #   class FooImporter
  #     include CIDB::Counting
  #
  #     def parse(file)
  #       parse_foo(file).each { |foo| import foo }
  #       puts "Imported %i foo of %i foo seen" % counted(:inserted, :foo)
  #       self
  #     end
  #
  #     def import(foo)
  #       inc :foo
  #       if foo.active?
  #         db_insert(foo)
  #         inc :inserted
  #       end
  #     end
  #   end
  #
  #   import = FooImporter.new.parse('foo.json')
  #   total = import.counted :foo
  #   imported = import.counted: imported
  #   puts "We imported #{imported} foo, skipped #{total - imported}"
  #
  # Counters are simple names to count against, they must respond to to_sym,
  # which is the key for the counter. All counters start at zero, referencing an
  # unknown counter creates it. Count things with increment and decrement (or inc
  # and dec for statsd fans):
  #
  #   inc: :apples
  #   inc: "oranges", amt: 2
  #
  # After that you can read you current count with the counted method:
  #
  #   puts "Counted #{counted(:apples)} apples"
  #   puts "Counted #{counted(':apples')} apples"
  #
  #   puts "Sorted %i, %i oranges and %i pears" % counted(:apples, :oranges, :pears) # "Sorted 1 apples, 2 oranges and 0 pears"
  #
  # Note1: Internally this is a Hash (@counts), but that is not exposed in the
  # public api and may change. If you want a hash of the currents counts, call
  # `counted_h`.
  #
  # Note2: Not currently thread safe. It should be! The uses cases will commenly
  # be threaded. Need to decide symantics of threads (per thead vs thread shared
  # counters).
  module Counting
    protected def counts
      @counts ||= Hash.new(0)
    end

    ##
    # Increase the named counter by 1 or amt if passed.
    def increment(key, amt: 1)
      counts[key.to_sym] += amt 
    end

    ##
    # Decrement the named counter by 1 or amt if passed.
    def decrement(key, amt: 1)
      counts[key.to_sym] -= amt
    end

    alias :inc :increment

    alias :dec :decrement

    def reset_counts
      counts.each_key { |k| @counts[k] = 0 }
    end

    ##
    # Returns the number counted for the passed count keys.
    # One arg, return single count.
    # multiple names, returns array of counts.
    def counted(*keys)
      return if keys.empty?
      return counts[keys[0].to_sym] if keys.size == 1
      ( keys.map { |k| counts[k.to_sym] } )
    end

    def counted_h(*keys)
      return counts.clone if keys.empty?
      counts.slice(*keys)
    end

  end #Counting
end #CIDB
