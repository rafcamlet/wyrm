require 'tty-tree'

module Scratch
  module Node
    class BaseNode
      attr_accessor :type, :children, :value, :ctx

      def initialize(type, value, children = [])
        @type = type
        @value = value
        @children = children.instance_of?(Array) ? children : [children]
      end

      def inspect_tree
        me = "#{self.class.name.split('::').last}: #{@value}"
        return me unless !@children.nil?

        { me => children.map(&:inspect_tree) }
      end

      def render
        TTY::Tree.new(inspect_tree).render
      end
    end
  end
end
