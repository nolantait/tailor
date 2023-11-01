module Tailor
  class Theme
    attr_accessor :styles

    def initialize(**theme)
      @methods = Object.new
      @styles = Hash.new do |hash, key|
        hash[key] = Style.new.tap do
          @methods.define_singleton_method(key) do
            hash[key]
          end
        end
      end

      theme.each do |key, css_classes|
        css_classes.each do |css_class|
          add(key, css_class)
        end
      end
    end

    def style(key, css_classes)
      css_classes << "" if css_classes.empty?
      css_classes.each do |css_class|
        add(key, css_class)
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

    # TODO: Setting a theme as a key, awkward
    def []=(key, theme)
      @styles.tap do |styles|
        styles[key] = theme
        @methods.define_singleton_method(key) do
          styles[key]
        end
      end
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

    protected

    def respond_to_missing?(method, *)
      @methods.respond_to?(method)
    end

    def method_missing(method, *, &block)
      if @methods.respond_to?(method)
        @methods.send(method, *, &block)
      else
        super
      end
    end
  end
end
