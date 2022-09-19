module Wyrm
  module Node
    class Condition
      def eval
        value.eavl ? children.first : children.last
      end
    end
  end
end
