module Frappongo
  class Map < Hash
    def initialize(hash=nil)
      super()
      if hash
        merge!(hash.is_a?(Hash) ? hash : Hash[hash])
      end
    end

    def to_s
      "{#{map {|args|
        args.map(&:to_s).join(' ')
      }.join(' ')}}"
    end

    def inspect
      "{#{map {|args|
        args.map(&:inspect).join(' ')
      }.join(' ')}}"
    end
  end
end
