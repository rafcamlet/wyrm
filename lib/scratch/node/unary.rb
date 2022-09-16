module Scratch
  module Node
    class Unary < BaseNode
      def eval(**opts)
        child_val = children.first.eval&.to_val
        raise "Can't prefix non numeric value" unless child_val.is_a?(BigDecimal)

        return child_val if @value.to_sym == :'+'

        BigDecimal(child_val * -1)
      end
    end
  end
end
