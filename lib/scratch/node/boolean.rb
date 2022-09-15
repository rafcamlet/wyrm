module Scratch
  module Node
    class Boolean < BaseNode
      def eval
        return true if @value == 'true'
        return false if @value == 'false'

        raise 'Wrong boolean value'
      end
    end
  end
end
