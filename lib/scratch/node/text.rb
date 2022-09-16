module Scratch
  module Node
    class Text < BaseNode
      def eval(**opts)
        @value.to_s
      end
    end
  end
end
