module Frappongo
  class Regexp
    def initialize(pattern, flags)
      @internal = ::Regexp.new(pattern, flags)
    end

    def value
      @internal
    end

    def to_s
      @internal.to_s
    end

    def inspect
      @internal.to_s.match(/^\(\?([imx]*)-[imx]*:(.+?)\)$/)
      "#\"#$2\"#$1"
    end
  end
end
