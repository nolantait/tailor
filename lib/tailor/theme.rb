module Tailor
  class Theme
    attr_reader :styles

    def initialize(**theme)
      @styles = Hash.new do
        Style.new
      end

      theme.each do |key, css_classes|
        css_classes.each do |css_class|
          add(key, css_class)
        end
      end
    end

    def add(key, css_class)
      tap do
        @styles[key] = @styles[key].add css_class
      end
    end

    def remove(key, css_class)
      tap do
        @styles[key].remove css_class
      end
    end

    def [](key)
      @styles[key]
    end

    def inherit(other_theme)
      other_theme.override(self)
    end

    def override(other_theme)
      @styles.merge(other_theme.styles)
    end

    def merge(other_theme)
      dup.tap do |theme|
        other_theme.styles.each do |key, style|
          theme.styles[key] = theme.styles[key].merge(style)
        end
      end
    end
  end
end