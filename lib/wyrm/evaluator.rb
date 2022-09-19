module Wyrm
  class Evaluator
    attr_reader :program, :output, :env, :stdout, :stack

    def initialize(code)
      @code = code
      @env = {}
      @stdout = []
      @stack = [{}]
    end

    def eval
      lexemes = Lexer.new(@code).call
      result = Parser.new(lexemes, self).call.eval
      self
    end

    def render
      lexemes = Lexer.new(@code).call
      result = Parser.new(lexemes, self).call.render
      puts '=' * 20
      pp @stack
      self
    end

    def find_in_stack(key)
      key = key.to_sym

      stack.find do |s|
        break if s[:__scope__]

        s[key]
      end&.fetch(key)
    end

    def put_in_stack(key, value)
      key = key.to_sym

      arr = stack.find do |s|
        break if s[:__scope__]

        s[key.to_sym]
      end

      if arr
        arr[key] = value
      else
        stack.first[key] = value
      end
    end

    def change_stack(new_stack)
      return yield if new_stack.nil?

      old_stack = stack
      @stack = new_stack
      yield
      @stack = old_stack
    end
  end
end
