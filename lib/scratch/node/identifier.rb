require 'bigdecimal'

module Scratch
  module Node
    class Identifier < BaseNode
      def eval
        if @value.include? '.'
          Float(@value)
        else
          Integer(@value)
        end
      end
    end
  end
end
