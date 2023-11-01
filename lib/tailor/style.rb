module Tailor
  class Style < Dry::Struct
    attribute :classes, Types::Array.of(Types::String).default([].freeze)

    def add(style)
      self.class.new(
        classes: classes + style.classes
      )
    end

    def remove(style)
      self.class.new(
        classes: classes - style.classes
      )
    end

    def merge(other_style)
      self.class.new(
        classes: (classes + other_style.classes).uniq
      )
    end

    def to_s
      classes.to_a.join(" ")
    end

    def to_str
      to_s
    end
  end
end
