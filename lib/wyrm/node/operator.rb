module Wyrm
  module Node
    class Operator < BaseNode
      def eval(**_opts)
        case @value.to_sym
        when :and then children.first.eval && children.last.eval
        when :or then children.first.eval || children.last.eval
        else
          arg1 = children.first.eval
          arg2 = children.last.eval
          return nil if arg1.nil? || arg2.nil?

          arg1.send(eval_method, arg2)
        end
      end

      def eval_method
        @value.to_sym
      end
    end
  end
end
