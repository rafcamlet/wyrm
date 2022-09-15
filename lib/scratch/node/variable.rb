require 'bigdecimal'

module Scratch
  module Node
    class Variable < BaseNode
      def eval
        var = ctx[@value.to_sym]
        raise "Undefined variable: '#{@value}'" if var.nil?

        var
      end
    end
  end
end
