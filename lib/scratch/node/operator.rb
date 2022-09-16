module Scratch
  module Node
    class Operator < BaseNode
      def eval(**opts)
        arg1 = children.first.eval
        arg2 = children.last.eval
        return nil if arg1.nil? || arg2.nil?

        arg1.send(eval_method, arg2)
      end

      def eval_method
        return :'!=' if type == :'<>'
        return :'!=' if type == :'!=='
        return :'==' if type == :'==='
        return :'==' if type == :'='

        type
      end
    end
  end
end
