# frozen_string_literal: true

module Tailor
  module DSL
    module ClassMethods
      def __tailor_namespace
        @__tailor_namespace ||= Namespace.new
      end

      def style(key, css_classes)
        __tailor_namespace.style(key, css_classes)
      end

      def tailor(key, &block)
        __tailor_namespace.namespace(key, &block)
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    def style
      @style ||= self.class.__tailor_namespace
    end

    def style=(other_style)
      @style = other_style
    end
  end
end
