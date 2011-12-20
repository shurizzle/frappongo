require 'parslet'
require 'boolean'
require 'frappongo/types'
require 'frappongo/extensions'

module Frappongo
  class Transform < Parslet::Transform
    rule(integer: {sign: simple(:s), value: simple(:i)}) {
      "#{s}#{Frappongo::Integer.sanitize i.to_s}".to_i
    }
    rule(integer: {value: simple(:i)}) {
      Frappongo::Integer.sanitize(i.to_s)
    }
    rule(integer: {sign: simple(:s), base: simple(:b), value: simple(:v)}) {
      "#{s}#{v}".to_i(b.to_s.to_i)
    }

    rule(float: {integer: simple(:i), e: simple(:e)}) {
      Float(i + e)
    }

    rule(character: simple(:c)) { Frappongo::Character.new(c) }

    rule(nihil: simple(:n)) { nil }
    rule(boolean: simple(:b)) {
      case b.to_s
      when 'false' then false
      when 'true' then true
      else raise 'Invalid value for boolean'
      end
    }
    rule(keyword: simple(:k)) { k.to_s.to_sym }

    rule(tuple: {key: simple(:k), value: simple(:v)}) { [k, v] }
    rule(elements: subtree(:e)) { e }

    rule(set: subtree(:e)) { Frappongo::Set.new(e) }
    rule(map: subtree(:e)) { Frappongo::Map.new(e) }
    rule(string: simple(:s)) { Frappongo::String.parse(s.to_s) }
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
    rule(ratio: {num: simple(:n), den: simple(:d)}) { Frappongo::Ratio.new(n, d) }

    rule(metadata: {meta: simple(:meta), arg: simple(:arg)}) {
      metadata = case meta
                 when ::String, Frappongo::Symbol
                   {tag: meta}
                 when ::Symbol
                   {meta => true}
                 when Frappongo::Map
                   meta
                 else nil
                 end

      arg.metadata.merge!(metadata)
      arg
    }

    rule(record: {namespace: simple(:nsx), name: simple(:n), arg: subtree(:a)}) {
      ns = nsx.to_s
      ns.empty? ? ns = nil : ns[ns.size - 1] = ''
      Frappongo::List.new([Frappongo::Symbol.new("->#{n}", ns), a])
    }

    rule(lambda: subtree(:e)) {
      Frappongo::List.new([Frappongo::Symbol.new('fn', 'frappongo.core')] + [Frappongo::Vector.new(e)] + e)
    }
  end
end
