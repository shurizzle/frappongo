require 'set'

module Frappongo
  class Set
    def initialize(elements)
      @internal = ::Set.new(elements)
    end

    def value
      @internal
    end

    def to_i
      "\#{#{@internal.to_a.map(&:to_s).join(' ')}}"
    end

    def inspect
      "\#{#{@internal.to_a.map(&:inspect).join(' ')}}"
    end
  end
end
