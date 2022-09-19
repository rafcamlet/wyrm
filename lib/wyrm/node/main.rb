module Wyrm
  module Node
    class Main
      attr_accessor :nodes

      def initialize
        @nodes = []
      end

      def <<(node)
        @nodes << node
      end

      def eval
        @nodes.each(&:eval)
      end

      def render
        @nodes.each { |n| puts n.render }
      end
    end
  end
end
