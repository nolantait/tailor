module Tailor
  class Theme
    attr_accessor :styles
    attr_accessor :custom_methods

    class Collection < Hash
      include Hashie::Extensions::MergeInitializer
      include Hashie::Extensions::MethodAccess
      include Hashie::Extensions::DeepMerge
    end

    Observer = ->(method_store) do
      Collection.new do |hash, key|
        hash[key] = Style.new.tap do
          method_store.define_singleton_method(key) do
            hash[key]
          end
        end
      end
    end

    def initialize_copy(other)
      self.custom_methods = Object.new
      self.styles = Observer.call(custom_methods)
      other.styles.each do |key, style|
        add(key, style)
      end
      super
    end

    def initialize(**theme)
      @custom_methods = Object.new
      @styles = Observer.call(@custom_methods)

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

    def add(key, styleable)
      case styleable
      when Theme then add_theme(key, styleable)
      when Style, String then add_style(key, styleable)
      else
        raise ArgumentError, "Invalid styleable: #{styleable.inspect}"
      end
    end

    def remove(key, css_class)
      tap do
        @styles[key] = @styles[key].remove css_class
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

    protected

    def respond_to_missing?(method, *)
      custom_methods.respond_to?(method)
    end

    def method_missing(method, *, &block)
      if custom_methods.respond_to?(method)
        custom_methods.send(method, *, &block)
      else
        super
      end
    end

    private

    def add_theme(key, theme)
      @styles.tap do |styles|
        styles[key] = theme
        @custom_methods.define_singleton_method(key) do
          styles[key]
        end
      end
    end

    def add_style(key, stringable)
      tap do
        @styles[key] = @styles[key].add stringable.to_s
      end
    end
  end
end
