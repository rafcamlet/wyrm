module Wyrm
  module Node
    class Definition < BaseNode
      attr_accessor :params, :anonymous, :context

      def eval(**opts)
        new_definition = self.dup
        new_definition.context = opts[:context]
        ctx.put_in_stack(@value, new_definition) unless anonymous?
        new_definition
      end

      def call(*args)
        result = nil
        ctx.change_stack(@context) do
          ctx.stack.unshift({})
          bind_params(args)
          result = children.map { |child| child.eval(context: ctx.stack.dup) }.last
          ctx.stack.shift
        end
        result
      end

      def inspect
        "#<Definition#{object_id}:#{@value}(#{params.map(&:value).join(', ')})>"
      end

      private

      def anonymous?
        @value.nil?
      end

      def bind_params(args)
        args.each.with_index do |v, i|
          ctx.put_in_stack(params[i].value, v)
        end
      end
    end
  end
end
