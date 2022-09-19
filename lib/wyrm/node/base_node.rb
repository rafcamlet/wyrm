require 'tty-tree'

module Wyrm
  module Node
    class BaseNode
      attr_accessor :type, :children, :value, :ctx

      def initialize(type, value, children = [], ctx: nil)
        @type = type
        @value = value
        @children = children.instance_of?(Array) ? children : [children]
        @ctx = ctx
      end

      def inspect_tree
        me = "#{self.class.name.split('::').last}: #{@value}"
        return me if @children.nil?

        { me => children.map(&:inspect_tree) }
      end

      def render
        puts '=' * 20
        TTY::Tree.new(inspect_tree).render
      end

      def eval
        raise 'not implemented'
      end
    end
  end
end
