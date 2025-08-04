# frozen_string_literal: true

require 'tty-prompt'
require 'pastel'
require 'tty-table'
require_relative 'generators/model_generator'
require_relative 'generators/controller_generator'
require_relative 'generators/migration_generator'

module Rails
  module Tui
    class Generator
      def initialize
        @prompt = TTY::Prompt.new
        @pastel = Pastel.new
      end

      def start
        display_welcome
        
        loop do
          choice = main_menu
          
          case choice
          when 'Model'
            ModelGenerator.new(@prompt, @pastel).generate
          when 'Controller'
            ControllerGenerator.new(@prompt, @pastel).generate
          when 'Migration'
            MigrationGenerator.new(@prompt, @pastel).generate
          when 'Exit'
            puts @pastel.green("\nGoodbye! 👋")
            break
          end
          
          puts "\n" + "=" * 50 + "\n"
        end
      end

      private

      def display_welcome
        puts @pastel.cyan.bold("\n🚀 Rails TUI Generator")
        puts @pastel.cyan("Interactive generator for Rails components\n")
      end

      def main_menu
        @prompt.select(@pastel.yellow("What would you like to generate?")) do |menu|
          menu.choice @pastel.green("📊 Model"), 'Model'
          menu.choice @pastel.blue("🎮 Controller"), 'Controller'
          menu.choice @pastel.magenta("📝 Migration"), 'Migration'
          menu.choice @pastel.red("❌ Exit"), 'Exit'
        end
      end
    end
  end
end
