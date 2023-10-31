module Tailor
  class Style
    attr_reader :classes

    def initialize
      @classes = Set.new
    end

    def add(css_class)
      tap do
        @classes.add css_class
      end
    end

    def remove(css_class)
      tap do
        @classes.delete css_class
      end
    end

    def merge(other_style)
      dup.tap do |style|
        style.classes.merge(other_style.classes)
      end
    end

    def to_s
      @classes.to_a.join(" ")
    end

    def to_str
      to_s
    end
  end
end
