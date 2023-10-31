module Tailor
  class Theme
    attr_reader :styles

    def initialize
      @styles = Hash.new do
        Style.new
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
      other_theme.merge(self)
    end

    def merge(other_theme)
      @styles.merge(other_theme.styles)
    end
  end
end
