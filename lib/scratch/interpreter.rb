module 
  class Interpreter
    attr_reader :program, :output, :env

    def initialize
      @output = []
      @env = {}
    end

    def interpret(ast)
      @program = ast

      interpret_nodes(program.expressions)
    end

    private

    def interpret_nodes(nodes)
      last_value = nil

      nodes.each do |node|
        last_value = interpret_node(node)
      end

      last_value
    end

    def interpret_node(node)
      interpreter_method = "interpret_#{node.type}"
      send(interpreter_method, node)
    end

    #...

  end
end
