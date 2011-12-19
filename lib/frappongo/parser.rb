require 'parslet'
require 'parslet/convenience'

module Frappongo

  class Parser < Parslet::Parser
    root :root

    rule(:root) {
      (space? >> list >> space?).repeat
    }

    rule(:list) {
      (str('(') >> body >> str(')')).as(:list) >> space?
    }

    rule(:body) {
      space? >> (atom >> space?).repeat.as(:elements)
    }

    rule(:atom) {
      literal | symbol | vector | map | set | list
    }

    rule(:simple_symbol) {
      (
        (
          match('[^^\(\[#{\\"~%:,/\s;@`\')\]}/\-+;0-9]') >> match('[^^(\[#{\\"~%:,/\s;@`\')\]}]').repeat >>
          (
            str(':') >> match('[^^(\[#{\\"~%:,/\s;@`\')\]}]')
          ).repeat
        ) | (
          match('[+-]') >> (match('[^^(\[#{\\"~%:,/\s;@`\')\]}0-9]') >> match('[^^(\[#{\\"~%:,/\s;@`\')\]}]').repeat).maybe >>
          (
            str(':') >> match('[^^(\[#{\\"~%:,/\s;@`\')\]}]')
          ).repeat
        )
      ) >> str('#').maybe
    }

    rule(:namespace) {
      (simple_symbol >> (str('.') >> simple_symbol).repeat).as(:namespace)
    }

    rule(:symbol) {
      (
        ((namespace >> str('/')).maybe >>
          simple_symbol.as(:name)) |
        str('/').as(:name)
      ).as(:symbol) >> space?
    }

    rule(:literal) {
      number | string | regexp | character | nihil | boolean | keyword
    }

    rule(:string) {
      str('"') >>
      (
        (
          str('\\') >> any |
          str('"').absnt? >> any
        ).repeat
      ).as(:string) >>
      str('"') >> space?
    }

    rule(:regexp) {
      (str('#') >>
        str('"') >>
        (
          (
            str('\\') >> any |
            str('"').absnt? >> any
          ).repeat
        ).as(:pattern) >>
        str('"') >> match('[ixm]').repeat.as(:flags)).as(:regexp) >> space?
    }

    rule(:number) {
      float | integer
    }

    rule(:integer) {
      (
        match('[+-]').maybe.as(:sign) >>


        (
          # <base>r<value> syntax
          (
            match('[2-9]') |
            match('[1-2]') >> match('[0-9]') |
            str('3') >> match('[0-6]')
          ).as(:base) >> match('[rR]') >> match('[0-9a-vA-V]').repeat(1).as(:value) |

          # octal
          (str('0') >> match('[0-7]').repeat(1)).as(:value) |

          # hex
          (str('0') >> match('[xX]') >> match('[0-9a-fA-F]').repeat(1)).as(:value) |

          # legacy
          (match('[1-9]') >> match('[0-9]').repeat).as(:value) | str('0').as(:value)
        )
      ).as(:integer) >> space?
    }

    rule(:float) {
      ((
        (str('+') | str('-')).maybe >>
        match('[0-9]').repeat(1)
      ).as(:integer) >>
      (
        str('.') >> match('[0-9]').repeat(1) |
        str('e') >> match('[0-9]').repeat(1)
      ).as(:e)).as(:float) >> space?
    }

    rule(:character) {
      (
        str('\\') >>
        (
          str('newline') | str('space') | str('tab') | str('backspace') | str('formfeed') | str('return') |
          (str('u') >> match('[0-9a-fA-F]')).repeat(4, 4) |
          (str('o') >> match('[0-3]').maybe >> match('[0-7]').repeat(1, 2)) |
          any
        )
      ).as(:character) >> space?
    }

    rule(:nihil) {
      str('nil').as(:nihil)
    }

    rule(:boolean) {
      (str('true') | str('false')).as(:boolean) >> space?
    }

    rule(:keyword) {
      str(':') >>
      (str(':') >> match('[-*+!_?[:alpha:]]') >> match('[-*+!_?[:alnum:]]').repeat |
        match('[-*+!_?[:alpha:]]') >> match('[-*+!_?[:alnum:]]').repeat).as(:keyword) >> space?
    }

    rule(:vector) {
      (str('[') >> space? >> body >> space? >> str(']')).as(:vector) >> space?
    }

    rule(:map) {
      (str('{') >> space? >>
        (atom.as(:key) >> atom.as(:value)).as(:tuple).repeat.as(:elements) >>
        space? >> str('}')).as(:map) >> space?
    }

    rule(:set) {
      space? >> (str('#{') >> space? >> body >> space? >> str('}')).as(:set) >> space?
    }

    rule(:space) {
      match('[\s,]').repeat(1)
    }

    rule(:space?) {
      space.maybe
    }
  end
end
