# frozen_string_literal: true

require "tty-table"

module Rails
  module Tui
    module Generators
      # Generator for creating Rails models with interactive prompts
      class ModelGenerator
        FIELD_TYPES = %w[string text integer bigint float decimal boolean date datetime time timestamp binary].freeze

        def initialize(prompt, pastel)
          @prompt = prompt
          @pastel = pastel
        end

        def generate
          puts @pastel.green.bold("\n📊 Model Generator")

          model_name = ask_for_model_name
          fields = collect_fields

          display_summary(model_name, fields)

          if @prompt.yes?(@pastel.yellow("Generate this model?"))
            generate_model_command(model_name, fields)
          else
            puts @pastel.red("Model generation cancelled.")
          end
        end

        private

        def ask_for_model_name
          @prompt.ask(@pastel.cyan("Enter model name:")) do |q|
            q.required true
            q.validate(/\A[A-Z][a-zA-Z0-9_]*\z/, "Model name must be in PascalCase (e.g., User, BlogPost)")
            q.modify :strip
          end
        end

        def collect_fields
          fields = []
          puts @pastel.cyan("\nAdd fields to your model (press Enter with empty name to finish):")

          loop do
            field = collect_single_field
            break unless field

            fields << field
          end

          fields
        end

        def collect_single_field
          field_name = @prompt.ask(@pastel.yellow("Field name:")) do |q|
            q.modify :strip
          end

          return nil if field_name.nil? || field_name.empty?

          field_type = select_field_type
          build_field(field_name, field_type)
        end

        def select_field_type
          @prompt.select(@pastel.yellow("Field type:")) do |menu|
            FIELD_TYPES.each { |type| menu.choice type }
            menu.choice "reference", "references"
          end
        end

        def build_field(field_name, field_type)
          if field_type == "references"
            reference_model = @prompt.ask(@pastel.yellow("Reference model name:")) do |q|
              q.required true
              q.modify :strip
            end
            { name: field_name, type: "references", reference: reference_model }
          else
            { name: field_name, type: field_type }
          end
        end

        def display_summary(model_name, fields)
          puts @pastel.cyan.bold("\n📋 Model Summary:")
          puts @pastel.white("Model: #{model_name}")
          display_fields_table(fields)
        end

        def display_fields_table(fields)
          if fields.any?
            table = TTY::Table.new(header: ["Field Name", "Type", "Reference"])
            fields.each do |field|
              reference = field[:reference] || "-"
              table << [field[:name], field[:type], reference]
            end
            puts table.render(:unicode)
          else
            puts @pastel.yellow("No fields specified")
          end
        end

        def generate_model_command(model_name, fields)
          command = build_model_command(model_name, fields)
          display_command(command)
          execute_if_confirmed(command)
        end

        def build_model_command(model_name, fields)
          command_parts = ["rails generate model #{model_name}"]
          command_parts.concat(build_field_arguments(fields))
          command_parts.join(" ")
        end

        def build_field_arguments(fields)
          fields.map do |field|
            if field[:type] == "references"
              "#{field[:name]}:references"
            else
              "#{field[:name]}:#{field[:type]}"
            end
          end
        end

        def display_command(command)
          puts @pastel.green.bold("\n🚀 Generated Command:")
          puts @pastel.white(command)
        end

        def execute_if_confirmed(command)
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
