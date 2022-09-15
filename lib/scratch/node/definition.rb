module Scratch
  module Node
    class Definition < BaseNode
      attr_accessor :params

      def eval
        ctx[@value.to_sym] = self
      end

      def call
        children.map(&:eval).last
      end

      def inspect
        "#<Definition:#{@value}>"
      end
    end
  end
end
