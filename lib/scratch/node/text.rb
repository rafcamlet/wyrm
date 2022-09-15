module Scratch
  module Node
    class Text < BaseNode
      def eval
        @value.to_s
      end
    end
  end
end
