module Wyrm
  module Node
    # Use blank? / present? to check for nullisness
    # Table parameters are returned as arrays so you may want flatten args
    class Function < BaseNode
      FunctionNotImplmentedError = Class.new(StandardError)

      NATIVE = [:print].freeze

      def eval(**opts)
        name = @value.to_sym
        if NATIVE.include? name
          public_send(@value.to_sym, *children.map(&:eval))
        elsif (needle = ctx.find_in_stack(name))
          needle.call(*children.map(&:eval))
        else
          raise_function_not_implmented unless respond_to?(@value.to_sym)
        end
      end

      def print(*args)
        output = args.join(' ')
        ctx.stdout << output
        puts output
      end

      def raise_function_not_implmented
        raise FunctionNotImplmentedError, "Function '#{@value}' is not implemented"
      end

      private
    end
  end
end
