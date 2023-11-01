module Tailor
  class Namespace
    # DOCS: Represents the public interface of Theme.
    # DSL uses this to manage nested themes.

    attr_reader :theme

    def initialize
      @theme = Theme.new
    end

    def [](key)
      @theme[key]
    end

    def add(key, styleable)
      case styleable
      when Namespace then @theme.add_namespace(key, styleable)
      when Style then @theme.add_style(key, styleable)
      when String then @theme.add(key, styleable)
      else
        raise ArgumentError, "Invalid styleable: #{styleable.inspect}"
      end
    end

    def style(key, classes)
      classes << "" if classes.empty?
      add key, Style.new(classes:)
    end

    def namespace(key, &block)
      self.class.new.tap do |namespace|
        namespace.instance_eval(&block)
        add key, namespace
      end
    end

    protected

    def respond_to_missing?(method, *)
      theme.styles.respond_to?(method)
    end

    def method_missing(method, *, &block)
      if theme.styles.respond_to?(method)
        theme.styles.send(method, *, &block)
      else
        super
      end
    end
  end
end
