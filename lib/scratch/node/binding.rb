require 'bigdecimal'

module Scratch
  module Node
    class Binding < BaseNode
      def eval
        ctx.env[@value.to_sym] = children.map(&:eval).last
      end
    end
  end
end
