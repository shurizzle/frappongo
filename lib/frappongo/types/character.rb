module Frappongo
  class Character
    CONVERSION_TABLE = Hash.new {|_, y|
      raise "Can't solve #{y} as a character"
    }.merge({
      'newline'   => "\n",
      'space'     => ' ',
      'tab'       => "\t",
      'backspace' => "\b",
      'formfeed'  => "\f",
      'return'    => "\r"
    }).freeze

    REVERSE_TABLE = Hash.new {|_, y|
      y
    }.merge(Hash[CONVERSION_TABLE.map{|x,y|[y,x]}]).freeze

    def initialize(char)
      @internal = case char
                  when /^\\(.)$/ then $1
                  when /^\\u([0-9A-Fa-f]{4})$/ then $1.to_i(16).chr
                  when /^\\o([0-3]?[0-7]{1,2})$/ then $1.to_i(8).chr
                  when /^\\(.+)$/ then CONVERSION_TABLE[$1]
                  else raise "Can't solve #{char} as a character"
                  end
    end

    def value
      @internal
    end

    def to_s
      '\\' + REVERSE_TABLE[@internal]
    end
    alias inspect to_s
  end
end
