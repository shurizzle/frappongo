module Frappongo
  class Float
    def initialize(float)
      @internal = Float(float)
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
