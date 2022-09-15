require 'scratch/node/main'
require 'scratch/node/boolean'
require 'scratch/node/function'
require 'scratch/node/number'
require 'scratch/node/operator'
require 'scratch/node/text'
require 'scratch/node/unary'



module Scratch
  class Parser
    PRECEDENCE = {
      '===': 3,
      '!==': 3,
      '==': 3,
      '!=': 3,
      '=': 3,
      '<>': 3,
      '>': 4,
      '<': 4,
      '>=': 4,
      '<=': 4,
      '+': 5,
      '-': 5,
      '*': 6,
      '/': 6,
      '(': 8,
      '**': 9
    }.freeze
    OPERATORS = PRECEDENCE.keys.freeze

    UNARY_OPERATORS = %i[- +].freeze
    PREFIX_PRECEDENCE = 7

    attr_reader :token

    def initialize(tokens)
      @tokens = tokens
      @tree = Node::Main.new
    end

    def call
      while !next_token.nil?
        get_token
        @tree << parse
      end

      @tree
    end

    private

    def parse(precedence = 0)
      node =
        if token.type == :identifier
          parse_identifier
        elsif token.type == :'('
          parse_group
        elsif token.type == :number
          Node::Number.new(token.type, token.lexeme)
        elsif token.type == :text
          Node::Text.new(token.type, token.lexeme)
        elsif token.type == :param
          Node::Param.new(token.type, token.lexeme)
        elsif token.type.in? UNARY_OPERATORS
          parse_unary_operator
        else
          raise "Can't parse token type: #{token.type} | lexeme: #{token.lexeme}"
        end

      return if node.nil?

      while !next_token.nil? && precedence < token_precedence(next_token)
        return node unless OPERATORS.include? next_token.type

        get_token
        node = parse_operator(node)
      end

      node
    end

    def parse_identifier
      return Node::Boolean.new(:boolean, token.lexeme) if %w[true false].include? token.lexeme

      lexeme = token.lexeme
      return nil unless get_if(:"(")

      Node::Function.new(:function, lexeme, parse_args)
    end

    def parse_operator(node)
      type = token.type
      lexeme = token.lexeme
      precedence = token_precedence(token)
      get_token
      Node::Operator.new(type, lexeme, [node, parse(precedence)])
    end

    def parse_unary_operator
      lexeme = token.lexeme
      get_token
      Node::Unary.new(:unary, lexeme, parse(PREFIX_PRECEDENCE))
    end

    def parse_group
      get_token
      node = parse
      return unless get_if(:')')

      node
    end

    def parse_args
      args = []

      # Emtpy function call
      if next_token.type == :")"
        get_token
        return args
      end

      get_token
      args << parse

      # There is more than one argument
      while next_token.type == :","
        get_token(2)
        args << parse
      end

      raise 'Function not closed' unless get_if(:")")

      args
    end

    def next_token
      @tokens[0]
    end

    def token_precedence(token)
      PRECEDENCE[token.type] || 0
    end

    def get_token(offset = 1)
      @token = @tokens.shift(offset).last
    end

    def get_if(type)
      return get_token if next_token.type == type

      raise "Expected #{type} but got #{next_token.type}"
    end
  end
end
