module Wyrm
  module Node
    class Return < BaseNode
      def eval
        throw :return, children.first&.eval
      end
    end
  end
end
