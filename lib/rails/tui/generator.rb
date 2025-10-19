# frozen_string_literal: true

require "tty-prompt"
require "pastel"
require "tty-table"
require_relative "generators/model_generator"
require_relative "generators/controller_generator"
require_relative "generators/migration_generator"

module Rails
  module Tui
    # Main generator class that provides the TUI interface
    class Generator
      def initialize
        @prompt = TTY::Prompt.new
        @pastel = Pastel.new
      end

      def start
        display_welcome
        run_generation_loop
      end

      private

      def run_generation_loop
        loop do
          choice = main_menu
          break if choice == "Exit"

          execute_generator(choice)
          display_separator
        end
        display_goodbye
      end

      def execute_generator(choice)
        generators = {
          "Model" => Generators::ModelGenerator,
          "Controller" => Generators::ControllerGenerator,
          "Migration" => Generators::MigrationGenerator
        }

        generator_class = generators[choice]
        generator_class&.new(@prompt, @pastel)&.generate
      end

      def display_separator
        puts "\n#{"=" * 50}\n"
      end

      def display_goodbye
        puts @pastel.green("\nGoodbye! 👋")
      end

      def display_welcome
        puts @pastel.cyan.bold("\n🚀 Rails TUI Generator")
        puts @pastel.cyan("Interactive generator for Rails components\n")
      end

      def main_menu
        @prompt.select(@pastel.yellow("What would you like to generate?")) do |menu|
          menu.choice @pastel.green("📊 Model"), "Model"
          menu.choice @pastel.blue("🎮 Controller"), "Controller"
          menu.choice @pastel.magenta("📝 Migration"), "Migration"
          menu.choice @pastel.red("❌ Exit"), "Exit"
        end
      end
    end
  end
end
