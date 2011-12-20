module Frappongo
  class Regexp < ::Regexp
    def initialize(pattern, flags)
      super(pattern, flags)
    end

    def value
      @internal
    end

    def inspect
      to_s.match(/^\(\?([imx]*)-[imx]*:(.+?)\)$/)
      "#\"#$2\"#$1"
    end
  end
end
