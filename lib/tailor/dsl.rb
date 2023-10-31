module Tailor
  module DSL
    module ClassMethods
      def style(key, css_classes)
        styles.style(key, css_classes)
      end

      def styles
        @styles ||= Theme.new
      end

      def tailor(key, &block)
        Theme.new.tap do |theme|
          theme.instance_eval(&block)
          styles[key] = theme
        end
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
