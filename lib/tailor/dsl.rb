module Tailor
  module DSL
    module ClassMethods
      def style(key, css_classes)
        styles.add(key, css_classes)
      end

      def styles
        @styles ||= Theme.new
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    def style
      @style ||= self.class.styles
    end

    def style=(other_style)
      @style = other_style
    end
  end
end
