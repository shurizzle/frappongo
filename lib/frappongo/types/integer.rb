module Frappongo
  class Integer
    def self.sanitize(x)
      case x
      when /^0x([0-9a-f]+)$/i then $1.to_i(16)
      when /^0([0-7]+)$/ then $1.to_i(8)
      when /^[0-9]+$/ then x.to_i
      else raise "Can't interpret #{x} as a integer."
      end
    end
  end
end
