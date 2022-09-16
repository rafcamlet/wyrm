require 'bigdecimal'

module Scratch
  module Node
    class Variable < BaseNode
      def eval
        var = ctx.env[@value.to_sym]
        raise "Undefined variable: '#{@value}'" if var.nil?

        var
      end
    end
  end
end
