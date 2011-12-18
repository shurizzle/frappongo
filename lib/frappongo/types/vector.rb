module Frappongo
  class Vector
    def initialize(vec)
      @internal = vec.to_a
    end

    def value
      @internal
    end

    def to_s
      "[#{@internal.map(&:to_s).join(' ')}]"
    end

    def inspect
      "[#{@internal.map(&:inspect).join(' ')}]"
    end
  end
end
