require 'parslet'
require 'frappongo/types'

module Frappongo
  class Transform < Parslet::Transform
    def sanitize_int(x)
      case x
      when /^0x([0-9a-f]+)$/i then $1.to_i(16)
      when /^0([0-7]+)$/ then $1.to_i(8)
      when /^[0-9]+$/ then x.to_i
      else raise "Can't interpret #{x} as a integer."
      end
    end

    rule(integer: {sign: simple(:s), value: simple(:i)}) {
      Frappongo::Integer.new("#{s}#{Frappongo::Integer.sanitize i.to_s}".to_i)
    }
    rule(integer: {value: simple(:i)}) {
      Frappongo::Integer.new(Frappongo::Integer.sanitize i.to_s)
    }
    rule(integer: {sign: simple(:s), base: simple(:b), value: simple(:v)}) {
      Frappongo::Integer.new("#{s}#{v}".to_i(b.to_s.to_i))
    }

    rule(float: {integer: simple(:i), e: simple(:e)}) {
      Frappongo::Float.new(i + e)
    }

    rule(character: simple(:c)) { Frappongo::Character.new(c) }

    rule(nihil: simple(:n)) { nil }
    rule(boolean: simple(:b)) { Frappongo::Boolean.new(b) }
    rule(keyword: simple(:k)) { Frappongo::Keyword.new(k) }
    rule(tuple: {key: simple(:k), value: simple(:v)}) { [k, v] }
    rule(elements: subtree(:e)) { e }
    rule(set: subtree(:e)) { Frappongo::Set.new(e) }
    rule(map: subtree(:e)) { Frappongo::Map.new(e) }
    rule(string: simple(:s)) { Frappongo::String.new(s) }
    rule(list: subtree(:e)) { Frappongo::List.new(e) }
    rule(vector: subtree(:e)) { Frappongo::Vector.new(e) }
    rule(regexp: {pattern: simple(:pattern), flags: simple(:f)}) {
      Frappongo::Regexp.new(pattern.to_s, f.to_s)
    }

    rule(symbol: {namespace: simple(:ns), name: simple(:n)}) {
      Frappongo::Symbol.new(n, ns)
    }
    rule(symbol: {name: simple(:n)}) {
      Frappongo::Symbol.new(n)
    }
  end
end
