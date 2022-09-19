require 'bigdecimal'

module Wyrm
  module Node
    class Number < BaseNode
      def eval(**opts)
        if @value.include? '.'
          Float(@value)
        else
          Integer(@value)
        end
      end
    end
  end
end
