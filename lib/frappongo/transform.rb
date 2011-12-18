require 'parslet'
require 'parslet/convenience'
require 'frappongo/types'

module Frappongo
  class Transform < Parslet::Transform
    rule(integer: {sign: simple(:s), value: simple(:i)}) {
      Frappongo::Integer.new("#{s}#{i}".to_i)
    }
    rule(integer: {value: simple(:i)}) {
      Frappongo::Integer.new(i.to_s.to_i)
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
