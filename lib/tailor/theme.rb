module Tailor
  class Theme
    attr_accessor :styles

    class Collection < Hash
      include Hashie::Extensions::MergeInitializer
      include Hashie::Extensions::MethodAccess
      include Hashie::Extensions::DeepMerge
    end

    CollectionFactory = -> do
      Collection.new do |hash, key|
        hash[key] = Style.new
      end
    end

    def initialize_copy(other)
      self.styles = CollectionFactory.call
      other.styles.each do |key, style|
        add(key, style)
      end
      super
    end

    def initialize(**theme)
      @styles = CollectionFactory.call

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
      styles.respond_to?(method)
    end

    def method_missing(method, *, &block)
      if styles.respond_to?(method)
        styles.send(method, *, &block)
      else
        super
      end
    end

    private

    def add_theme(key, theme)
      styles.tap do |styles|
        styles[key] = theme
      end
    end

    def add_style(key, stringable)
      tap do
        @styles[key] = @styles[key].add stringable.to_s
      end
    end
  end
end
