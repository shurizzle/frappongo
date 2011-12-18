module Frappongo
  class String
    def initialize(string)
      @internal = string.to_s
    end

    def value
      @internal
    end

    def to_s
      @internal
    end

    def inspect
      @internal.inspect
    end
  end
end
