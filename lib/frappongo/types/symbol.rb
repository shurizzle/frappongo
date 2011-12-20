module Frappongo
  class Symbol
    def initialize(name, namespace=nil)
      @name = name.to_s
      @namespace = namespace ? namespace.to_s : nil
    end

    def to_s
      "#{@namespace || 'this'}/#{@name}"
    end
    alias inspect to_s
  end
end
