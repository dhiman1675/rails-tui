# frozen_string_literal: true

require_relative "tui/version"
require_relative "tui/cli"
require_relative "tui/generator"

module Rails
  module Tui
    class Error < StandardError; end
  end
end
