require 'parslet'
require 'parslet/convenience'

class Object
  def metadata
    @metadata ||= Frappongo::Map.new
  end

  def metadata=(meta)
    @metadata = meta.is_a?(Frappongo::Map) ? meta : Frappongo::Map.new(meta)
  end
end

module Parslet; module Atoms
  class Base
    def ignore
      ::Parslet::Atoms::Ignore.new(self)
    end
  end

  class Ignore < Base
    attr_reader :parslet
    def initialize(parslet)
      super()
      @parslet = parslet
    end

    def apply(source, context) # :nodoc:
      value = parslet.apply(source, context)
      return value if value.error?
      success(nil)
    end

    def to_s_inner(prec)
      parslet.to_s(prec)
    end
  end
end; end
