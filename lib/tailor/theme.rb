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
        add_style(key, style)
      end
      super
    end

    def initialize(**theme)
      @styles = CollectionFactory.call

      theme.each do |key, css_classes|
        add(key, css_classes)
      end
    end

    def add_namespace(key, namespace)
      styles.tap do |styles|
        styles[key] = namespace
      end
    end

    def add_style(key, style)
      tap do
        styles[key] = styles[key].add style
      end
    end

    def add(key, classes)
      tap do
        Array(classes).tap do |classes|
          classes << "" if classes.empty?
          styles[key] = styles[key].add Style.new(classes:)
        end
      end
    end

    def remove(key, css_class)
      tap do
        styles[key] = styles[key].remove Style.new(classes: Array(css_class))
      end
    end

    def [](key)
      styles[key]
    end

    def inherit(other_theme)
      other_theme.override(self)
    end

    def override(other_theme)
      styles.merge(other_theme.styles)
    end

    def merge(other_theme)
      dup.tap do |theme|
        other_theme.styles.each do |key, style|
          theme.styles[key] = theme.styles[key].merge(style)
        end
      end
    end


    private

  end
end
