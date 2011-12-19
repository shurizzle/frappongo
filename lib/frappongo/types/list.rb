module Frappongo
  class List < Array
    def initialize(list)
      super(list.to_a)
    end

    def to_s
      "(#{map(&:to_s).join(' ')})"
    end

    def inspect
      "(#{map(&:inspect).join(' ')})"
    end
  end
end
