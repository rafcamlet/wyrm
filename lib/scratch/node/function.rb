module Scratch
  module Node
    # Use blank? / present? to check for nullisness
    # Table parameters are returned as arrays so you may want flatten args
    class Function < BaseNode
      FunctionNotImplmentedError = Class.new(StandardError)

      NATIVE = [:print].freeze

      def eval
        name = @value.to_sym
        if NATIVE.include? name
          public_send(@value.to_sym, *children.map(&:eval))
        elsif !ctx[name].nil?
          ctx[name].call
        else
          raise_function_not_implmented unless respond_to?(@value.to_sym)
        end
      end

      def print(*args)
        puts args.join ' '
      end

      def raise_function_not_implmented
        raise FunctionNotImplmentedError, "Function '#{@value}' is not implemented"
      end
    end
  end
end
