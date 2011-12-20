require 'forwardable'

module Frappongo
  class Ratio
    extend Forwardable

    def_delegators :@internal, :*, :**, :+, :-, :/, :quo, :<=>, :==, :denominator, \
      :fdiv, :numerator, :round, :to_f, :to_i
    def initialize(*r)
      @internal = ::Kernel::Rational(*r)
    end

    def ceil(precision=0)
      res = @internal.ceil(precision)
      res = self.class.new(res) if res.is_a?(::Rational)
      res
    end

    def floor(precision=0)
      res = @internal.floor(precision)
      res = self.class.new(res) if res.is_a?(::Rational)
      res
    end

    def rationalize(eps=nil)
      if eps
        self.class.new(@internal.rationalize(eps))
      else
        self
      end
    end

    def round(precision=0)
      res = @internal.round(precision)
      res = self.class.new(res) if res.is_a?(::Rational)
      res
    end

    def truncate(precision=0)
      res = @internal.truncate(precision)
      res = self.class.new(res) if res.is_a?(::Rational)
      res
    end

    def to_r
      self
    end

    def to_s
      "#{numerator}/#{denominator}"
    end
    alias inspect to_s
  end
end
