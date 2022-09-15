module Scratch
  class Evaluator
    attr_reader :program, :output, :env

    def initialize(code)
      @code = code
    end

    def eval
      lexemes = Lexer.new(@code).call
      result = Parser.new(lexemes).call.eval
    end

    def render
      lexemes = Lexer.new(@code).call
      result = Parser.new(lexemes).call.render
    end


    # def initialize
    #   @output = []
    #   @env = {}
    # end

    # def interpret(ast)
    #   @program = ast

    #   interpret_nodes(program.expressions)
    # end

    # private

    # def interpret_nodes(nodes)
    #   last_value = nil

    #   nodes.each do |node|
    #     last_value = interpret_node(node)
    #   end

    #   last_value
    # end

    # def interpret_node(node)
    #   interpreter_method = "interpret_#{node.type}"
    #   send(interpreter_method, node)
    # end

    # def interpret_var_binding(var_binding)
    #   env[var_binding.var_name_as_str] = interpret_node(var_binding.right)
    # end

    # def interpret_unary_operator(unary_op)
    #   case unary_op.operator
    #   when :'-'
    #     -(interpret_node(unary_op.operand))
    #   else # :'!'
    #     !(interpret_node(unary_op.operand))
    #   end
    # end

    # def interpret_number(number)
    #   number.value
    # end

  end
end
