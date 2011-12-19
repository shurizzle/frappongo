require 'parslet'
require 'boolean'
require 'frappongo/types'

class Object
  def metadata
    @metadata ||= Frappongo::Map.new
  end

  def metadata=(meta)
    @metadata = case meta
                when Frappongo::Map
                  meta
                when Hash
                  Frappongo::Map.new(meta.to_a)
                end
  end
end

module Frappongo
  class Transform < Parslet::Transform
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
    rule(boolean: simple(:b)) {
      case b.to_s
      when 'false' then false
      when 'true' then true
      else raise 'Invalid value for boolean'
      end
    }
    rule(keyword: simple(:k)) { k.to_sym }
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
    rule(ratio: {num: simple(:n), den: simple(:d)}) { ::Kernel.Rational(n.value, d.value) }

    rule(metadata: {meta: simple(:meta), arg: simple(:arg)}) {
      metadata = case meta
                 when Frappongo::String, Frappongo::Symbol
                   {tag: meta}
                 when ::Symbol
                   {meta => true}
                 when Frappongo::Map
                   meta
                 else nil
                 end

      arg.metadata = arg.metadata.merge(metadata)
      arg
    }
  end
end
