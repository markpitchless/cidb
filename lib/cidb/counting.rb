#!/usr/bin/env ruby
#vim: sw=2 ts=2 sts=2:

module CIDB
  ##
  # Mixin to add methods for counting things.
  #
  # It is pretty common for classes doing scanning, import type work to need to
  # keep (integer) counts of things. Items parsed, number skipped, failed, etc.
  # Just import Counting, call inc to count and counted to get the count.
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
  # `counted_h`. If you need non counting symantics, this mod is not for you.
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

    ##
    # Reset counters (to zero).
    # With no args reset all counters. With args, reset only the named counters.
    def reset_counts(*args)
      if args.empty?
        counts.each_key { |k| @counts[k] = 0 }
      else
        args.each { |k| @counts[k] = 0 }
      end
    end

    ##
    # Returns the number counted for the passed keys. All keys have to_sym
    # called to get the actual key to look up.
    # One arg, return single count. Multiple names, returns array of counts.
    def counted(*keys)
      return if keys.empty?
      return counts[keys[0].to_sym] if keys.size == 1
      ( keys.map { |k| counts[k.to_sym] } )
    end

    ##
    # Return a new hash with the current counts. All keys are symbols.
    # With aguments, the hash only contains those keys (is sliced).
    def counted_h(*keys)
      return counts.clone if keys.empty?
      counts.slice(*keys)
    end

  end #Counting
end #CIDB
