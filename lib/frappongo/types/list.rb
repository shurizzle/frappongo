module Frappongo
  class List
    def initialize(list)
      @internal = list.to_a
    end

    def value
      @internal
    end

    def to_s
      "(#{@internal.map(&:to_s).join(' ')})"
    end

    def inspect
      "(#{@internal.map(&:inspect).join(' ')})"
    end
  end
end
