require 'wyrm/token'
require 'strscan'

module Wyrm
  class Lexer
    ONE_CHAR_LEX = ['(', ')', ':', ',', '.', '-', '+', '/', "\n"].freeze
    MULTI_CHAR_LEX = ['==', '!=', '==', '>=', '<=', '**', '='].freeze
    KEYWORD = ['end', 'and', 'or', 'return'].freeze

    def initialize(source)
      raise 'source not provided' if source.nil? || source == ''

      @source = StringScanner.new(source)
      @tokens = []
    end

    def call
      until @source.eos?
        c = @source.getch

        next if c =~ /\s/ && c != "\n"

        @source.skip_until(/\n/) and next if c == '#'

        if ONE_CHAR_LEX.include?(c)
          @tokens << Token.new(c)
        elsif chars_tree.keys.include?(c)
          hash = chars_tree[c]
          lex = c
          loop do
            hash = hash[@source.peek(1)]
            break @tokens << Token.new(lex) if hash.nil?

            lex += @source.getch
          end
        elsif c == '"'
          @tokens << Token.new(:text, @source.scan_until(/"/)[0..-2])
        elsif c == "'"
          @tokens << Token.new(:text, @source.scan_until(/'/)[0..-2])
        elsif c =~ /\d/
          @tokens << Token.new(:number, c + @source.scan(/[\d.]*/).to_s)
        elsif c =~ /\w/
          lex = c + @source.scan(/[\w_]*/).to_s
          type = KEYWORD.include?(lex) ? lex.to_sym : :identifier
          @tokens << Token.new(type, lex)
        end
      end
      @tokens
    end

    private

    def chars_tree
      @chars_tree ||=
      {}.tap do |result|
        l = lambda do |obj, keys|
          key = keys.shift
          obj[key] ||= {}
          l.call(obj[key], keys) unless keys.empty?
        end

        MULTI_CHAR_LEX.each { |str| l.call(result, str.chars) }
      end
    end
  end
end
