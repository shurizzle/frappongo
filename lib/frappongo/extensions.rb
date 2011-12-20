class Object
  def metadata
    @metadata ||= Frappongo::Map.new
  end

  def metadata=(meta)
    @metadata = meta.is_a?(Frappongo::Map) ? meta : Frappongo::Map.new(meta)
  end
end

class Parslet::Atoms::Named
  def apply(source, context) # :nodoc:
    value = parslet.apply(source, context)

    if name.nil?
      success(nil)
    else
      return value if value.error?
      success(
        produce_return_value(
          value.result))
    end
  end
end
