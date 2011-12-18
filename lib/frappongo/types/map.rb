module Frappongo
  class Map
    def initialize(hash)
      @internal = Hash[hash]
    end

    def value
      @internal
    end

    def to_s
      "{#{@internal.map {|args|
        args.map(&:to_s).join(' ')
      }.join(' ')}}"
    end

    def inspect
      "{#{@internal.map {|args|
        args.map(&:inspect).join(' ')
      }.join(' ')}}"
    end
  end
end
