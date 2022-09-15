require 'scratch/node/main'
require 'scratch/node/definition'
require 'scratch/node/boolean'
require 'scratch/node/function'
require 'scratch/node/number'
require 'scratch/node/operator'
require 'scratch/node/text'
require 'scratch/node/unary'
require 'scratch/node/binding'
require 'scratch/node/variable'



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

    attr_reader :token, :ctx

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
        if token.type == :identifier
          parse_identifier
        elsif token.type == :'('
          parse_group
        elsif token.type == :number
          Node::Number.new(token.type, token.lexeme)
        elsif token.type == :text
          Node::Text.new(token.type, token.lexeme)
        elsif UNARY_OPERATORS.include? token.type
          parse_unary_operator
        elsif token.type == :"\n"
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
      return Node::Boolean.new(:boolean, token.lexeme) if %w[true false].include? token.lexeme
      return parse_binding if next_token.type == :'='
      return parse_function if token.lexeme == 'fn'
      return parse_function_call if next_token.type == :'('

      Node::Variable.new(:variable, token.lexeme, ctx: ctx)
    end

    def parse_function_call
      lexeme = token.lexeme
      return nil unless get_if(:"(")

      Node::Function.new(:function, lexeme, parse_args, ctx: ctx)
    end

    def parse_binding
      name = token.lexeme
      get_token 2
      node = Node::Binding.new(:binding, name, parse, ctx: ctx)
      get_if :"\n"
      node
    end

    def parse_function
      name = get_if(:identifier)
      #params
      return nil unless get_if(:"(")
      return nil unless get_if(:")")

      oneline = next_token.type != :"\n"

      return nil unless oneline || get_if(:"\n")

      # body
      children = []
      get_token

      while token.type != (oneline ? :"\n" : :end)
        node = parse
        children << node unless node.nil?
        get_token
      end

      Node::Definition.new(:definition, name.lexeme, children, ctx: ctx)
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
      return get_token if next_token&.type == type

      raise "Expected '#{type}' but got '#{next_token&.type}'"
    end
  end
end
