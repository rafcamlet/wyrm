require 'bigdecimal'

module Wyrm
  module Node
    class Variable < BaseNode
      def eval(**opts)
        var = ctx.find_in_stack(@value.to_sym)
        raise "Undefined variable: '#{@value}'" if var.nil?

        var
      end
    end
  end
end
