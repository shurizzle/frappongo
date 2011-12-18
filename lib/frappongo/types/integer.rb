module Frappongo
  class Integer
    def initialize(int)
      @internal = Integer(int)
    end

    def value
      @internal
    end

    def to_s
      @internal.to_s
    end
    alias inspect to_s
  end
end
