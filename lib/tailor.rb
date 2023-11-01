# frozen_string_literal: true

require "dry/types"
require "dry/struct"
require "hashie"

require_relative "tailor/version"
require_relative "tailor/types"
require_relative "tailor/style"
require_relative "tailor/theme"
require_relative "tailor/namespace"
require_relative "tailor/dsl"

module Tailor
  module_function

  class Error < StandardError; end
  # Your code goes here...

  def new(...)
    Theme.new(...)
  end
end
