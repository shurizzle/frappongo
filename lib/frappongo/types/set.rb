require 'set'

module Frappongo
  class Set < ::Set
    def initialize(elements)
      super(elements)
    end

    def to_s
      "\#{#{to_a.map(&:to_s).join(' ')}}"
    end

    def inspect
      "\#{#{to_a.map(&:inspect).join(' ')}}"
    end
  end
end
