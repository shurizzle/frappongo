module Frappongo
  class Keyword
    def initialize(key)
      @internal = key.to_sym
    end

    def value
      @internal
    end

    def to_s
      @internal.to_s
    end

    def inspect
      @internal.inspect
    end
  end
end
