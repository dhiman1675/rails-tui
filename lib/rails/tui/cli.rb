# frozen_string_literal: true

require "thor"
require "tty-prompt"
require "pastel"
require_relative "generator"

module Rails
  module Tui
    # Command Line Interface for Rails TUI generator
    class CLI < Thor
      desc "generate", "Launch interactive TUI to generate Rails components"
      def generate
        Generator.new.start
      end

      desc "version", "Show version"
      def version
        puts Rails::Tui::VERSION
      end

      default_task :generate
    end
  end
end
