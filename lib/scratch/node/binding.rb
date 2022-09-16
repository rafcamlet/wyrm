require 'bigdecimal'

module Scratch
  module Node
    class Binding < BaseNode
      def eval(**opts)
        ctx.put_in_stack(@value.to_sym, children.map(&:eval).last)
      end
    end
  end
end
