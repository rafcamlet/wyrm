require 'tty-tree'

module Wyrm
  module Node
    class BaseNode
      attr_accessor :children, :value, :ctx

      def initialize(value, children = [], ctx: nil)
        @value = value
        @children = children.instance_of?(Array) ? children : [children]
        @ctx = ctx
      end

      def inspect_tree
        me = "#{name}: #{@value}"
        return me if @children.nil?

        { me => children.map(&:inspect_tree) }
      end

      def render
        puts '=' * 20
        TTY::Tree.new(inspect_tree).render
      end

      def eval
        raise 'eval not implemented'
      end

      def type
        @type ||= name.downcase
      end

      private

      def name
        @name ||= self.class.name.split('::').last
      end
    end
  end
end
