module Frappongo
  class String
    CONVERSION_TABLE = Hash.new {|h, c| c}.merge({
      't'   => "\t",
      'r'   => "\r",
      'n'   => "\n",
      '\\'  => '\\',
      '"'   => '"',
      'b'   => "\b",
      'f'   => "\f"
    }).freeze

    def self.parse(str)
      str.gsub(/\\u([0-9a-fA-F]{1,4})/) {|x|
        x[2..-1].to_i(16).chr
      }.gsub(/\\([0-7]{1,3})/) {|x|
        x[1..-1].to_i(8).chr
      }.gsub(/\\./) {|x|
        CONVERSION_TABLE[x[1..-1]]
      }
    end
  end
end
