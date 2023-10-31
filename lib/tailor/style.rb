module Tailor
  class Style
    def initialize
      @style = Set.new
    end

    def add(css_class)
      tap do
        @style.add css_class
      end
    end

    def remove(css_class)
      tap do
        @style.delete css_class
      end
    end

    def to_s
      @style.to_a.join(" ")
    end
  end
end
