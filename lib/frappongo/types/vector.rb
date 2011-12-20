module Frappongo
  class Vector < ::Array
    def initialize(vec)
      super
    end

    def to_s
      "[#{map(&:to_s).join(' ')}]"
    end

    def inspect
      "[#{map(&:inspect).join(' ')}]"
    end
  end
end
