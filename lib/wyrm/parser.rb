require 'wyrm/node/main'
require 'wyrm/node/definition'
require 'wyrm/node/boolean'
require 'wyrm/node/function'
require 'wyrm/node/number'
require 'wyrm/node/operator'
require 'wyrm/node/text'
require 'wyrm/node/unary'
require 'wyrm/node/binding'
require 'wyrm/node/variable'
require 'wyrm/node/return'

module Wyrm
  class Parser
    PRECEDENCE = {
      'or': 1,
      'and': 2,
      '==': 3,
      '!=': 3,
      '=': 3,
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

    attr_reader :token, :ctx, :tokens

    def initialize(tokens, ctx)
      @tokens = tokens
      @tree = Node::Main.new
      @ctx = ctx
    end

    def call
      while !next_token.nil?
        get_token
        node = parse
        @tree << node unless node.nil?
      end

      @tree
    end

    private

    def parse(precedence = 0)
      node =
        if token == :identifier
          parse_identifier
        elsif token == :'('
          parse_group
        elsif token == :number
          Node::Number.new(token.lexeme)
        elsif token == :text
          Node::Text.new(token.lexeme)
        elsif UNARY_OPERATORS.include? token.type
          parse_unary_operator
        elsif token == :return
          get_token
          Node::Return.new(nil, parse)
        elsif token == :"\n"
          nil
        else
          raise "Can't parse token type: #{token.type.inspect} | lexeme: #{token.lexeme.inspect}"
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
      return Node::Boolean.new(token.lexeme) if %w[true false].include? token.lexeme
      return parse_binding if next_token == :'='
      return parse_function if token.lexeme == 'fn'
      return parse_function_call if next_token == :'('

      Node::Variable.new(token.lexeme, ctx: ctx)
    end

    def parse_function_call
      lexeme = token.lexeme
      return nil unless get_if(:"(")

      Node::Function.new(lexeme, parse_args, ctx: ctx)
    end

    def parse_binding
      name = token.lexeme
      get_token 2
      Node::Binding.new(name, parse, ctx: ctx)
    end

    def parse_function
      params = []

      name = get_token if next_token == :identifier

      get_if(:"(")
      get_token

      if token != :")"
        params << parse

        # There is more than one argument
        while next_token == :","
          get_token(2)
          params << parse
        end

        get_if(:")")
      end

      oneline = next_token != :"\n"

      return nil unless oneline || get_if(:"\n")

      # body
      children = []

      loop do
        get_token
        node = parse
        children << node unless node.nil?

        get_token and break if next_token == :end
        break if oneline && next_token == :"\n"
      end


      node = Node::Definition.new(name&.lexeme, children, ctx: ctx)
      node.params = params
      node
    end

    def parse_operator(node)
      lexeme = token.lexeme
      precedence = token_precedence(token)
      get_token
      Node::Operator.new(lexeme, [node, parse(precedence)])
    end

    def parse_unary_operator
      lexeme = token.lexeme
      get_token
      Node::Unary.new(lexeme, parse(PREFIX_PRECEDENCE))
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
      if next_token == :")"
        get_token
        return args
      end

      get_token
      args << parse

      # There is more than one argument
      while next_token == :","
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
      return get_token if next_token&.type == type

      raise "Expected '#{type.inspect}' but got '#{next_token&.type}'"
    end
  end
end
