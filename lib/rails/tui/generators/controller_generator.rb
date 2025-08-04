# frozen_string_literal: true

require 'tty-table'

module Rails
  module Tui
    module Generators
      class ControllerGenerator
        COMMON_ACTIONS = %w[index show new create edit update destroy].freeze
        
        def initialize(prompt, pastel)
          @prompt = prompt
          @pastel = pastel
        end

        def generate
          puts @pastel.blue.bold("\n🎮 Controller Generator")
          
          controller_name = get_controller_name
          actions = collect_actions
          
          display_summary(controller_name, actions)
          
          if @prompt.yes?(@pastel.yellow("Generate this controller?"))
            generate_controller_command(controller_name, actions)
          else
            puts @pastel.red("Controller generation cancelled.")
          end
        end

        private

        def get_controller_name
          @prompt.ask(@pastel.cyan("Enter controller name:")) do |q|
            q.required true
            q.validate(/\A[A-Z][a-zA-Z0-9_]*\z/, "Controller name must be in PascalCase (e.g., Users, BlogPosts)")
            q.modify :strip
          end
        end

        def collect_actions
          actions = []
          
          # Ask if they want common RESTful actions
          if @prompt.yes?(@pastel.cyan("Include common RESTful actions (index, show, new, create, edit, update, destroy)?"))
            actions.concat(COMMON_ACTIONS)
          else
            # Let them select specific common actions
            selected_actions = @prompt.multi_select(@pastel.cyan("Select actions to include:")) do |menu|
              COMMON_ACTIONS.each { |action| menu.choice action }
            end
            actions.concat(selected_actions)
          end
          
          # Ask for custom actions
          puts @pastel.cyan("\nAdd custom actions (press Enter with empty name to finish):")
          
          loop do
            action_name = @prompt.ask(@pastel.yellow("Custom action name:")) do |q|
              q.modify :strip
            end
            
            break if action_name.nil? || action_name.empty?
            
            actions << action_name unless actions.include?(action_name)
          end
          
          actions.uniq
        end

        def display_summary(controller_name, actions)
          puts @pastel.cyan.bold("\n📋 Controller Summary:")
          puts @pastel.white("Controller: #{controller_name}")
          
          if actions.any?
            puts @pastel.white("Actions: #{actions.join(', ')}")
          else
            puts @pastel.yellow("No actions specified")
          end
        end

        def generate_controller_command(controller_name, actions)
          command_parts = ["rails generate controller #{controller_name}"]
          command_parts.concat(actions) if actions.any?
          
          command = command_parts.join(" ")
          
          puts @pastel.green.bold("\n🚀 Generated Command:")
          puts @pastel.white(command)
          
          if @prompt.yes?(@pastel.yellow("\nExecute this command now?"))
            puts @pastel.cyan("Executing: #{command}")
            system(command)
          else
            puts @pastel.yellow("Command ready to copy and paste!")
          end
        end
      end
    end
  end
end
