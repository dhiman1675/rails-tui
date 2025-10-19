# frozen_string_literal: true

require "tty-table"

module Rails
  module Tui
    module Generators
      # Generator for creating Rails migrations with interactive prompts
      class MigrationGenerator
        MIGRATION_TYPES = [
          "Create table",
          "Add column",
          "Remove column",
          "Change column",
          "Rename column",
          "Add index",
          "Remove index",
          "Custom migration"
        ].freeze

        FIELD_TYPES = %w[string text integer bigint float decimal boolean date datetime time timestamp binary].freeze

        def initialize(prompt, pastel)
          @prompt = prompt
          @pastel = pastel
        end

        def generate
          puts @pastel.magenta.bold("\n📝 Migration Generator")
          migration_type = select_migration_type
          execute_migration_type(migration_type)
        end

        def execute_migration_type(migration_type)
          method = migration_method_map[migration_type]
          send(method) if method
        end

        def migration_method_map
          {
            "Create table" => :generate_create_table_migration,
            "Add column" => :generate_add_column_migration,
            "Remove column" => :generate_remove_column_migration,
            "Change column" => :generate_change_column_migration,
            "Rename column" => :generate_rename_column_migration,
            "Add index" => :generate_add_index_migration,
            "Remove index" => :generate_remove_index_migration,
            "Custom migration" => :generate_custom_migration
          }
        end

        private

        def select_migration_type
          @prompt.select(@pastel.cyan("What type of migration?")) do |menu|
            MIGRATION_TYPES.each { |type| menu.choice type }
          end
        end

        def generate_create_table_migration
          table_name = ask_for_table_name
          fields = collect_fields
          migration_name = "Create#{table_name.capitalize}"

          display_create_table_summary(migration_name, table_name, fields)

          return unless @prompt.yes?(@pastel.yellow("Generate this migration?"))

          command = build_create_table_command(migration_name, fields)
          execute_command(command)
        end

        def build_create_table_command(migration_name, fields)
          command_parts = ["rails generate migration #{migration_name}"]
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

        def generate_add_column_migration
          table_name = ask_for_table_name
          column_name = ask_for_column_name
          column_type = ask_for_column_type

          migration_name = "Add#{column_name.capitalize}To#{table_name.capitalize}"
          command = "rails generate migration #{migration_name} #{column_name}:#{column_type}"

          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Add column '#{column_name}' (#{column_type}) to '#{table_name}' table")

          execute_if_confirmed(command)
        end

        def generate_remove_column_migration
          table_name = ask_for_table_name
          column_name = ask_for_column_name

          migration_name = "Remove#{column_name.capitalize}From#{table_name.capitalize}"
          command = "rails generate migration #{migration_name} #{column_name}"

          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Remove column '#{column_name}' from '#{table_name}' table")

          execute_if_confirmed(command)
        end

        def generate_change_column_migration
          table_name = ask_for_table_name
          column_name = ask_for_column_name
          new_type = ask_for_column_type

          migration_name = "Change#{column_name.capitalize}In#{table_name.capitalize}"
          command = "rails generate migration #{migration_name}"

          display_change_column_summary(migration_name, column_name, new_type, table_name)
          execute_if_confirmed(command)
        end

        def display_change_column_summary(migration_name, column_name, new_type, table_name)
          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Change column '#{column_name}' to type '#{new_type}' in '#{table_name}' table")
          note = "Note: You'll need to manually edit the migration file to "
          note += "specify the change_column method"
          puts @pastel.yellow(note)
        end

        def generate_rename_column_migration
          table_name = ask_for_table_name
          old_name = ask_for_current_column_name
          new_name = ask_for_new_column_name

          migration_name = build_rename_migration_name(old_name, new_name, table_name)
          command = "rails generate migration #{migration_name}"

          display_rename_summary(migration_name, old_name, new_name, table_name)
          execute_if_confirmed(command)
        end

        def ask_for_current_column_name
          @prompt.ask(@pastel.cyan("Current column name:")) do |q|
            q.required true
            q.modify :strip
          end
        end

        def ask_for_new_column_name
          @prompt.ask(@pastel.cyan("New column name:")) do |q|
            q.required true
            q.modify :strip
          end
        end

        def build_rename_migration_name(old_name, new_name, table_name)
          "Rename#{old_name.capitalize}To#{new_name.capitalize}In#{table_name.capitalize}"
        end

        def display_rename_summary(migration_name, old_name, new_name, table_name)
          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Rename column '#{old_name}' to '#{new_name}' in '#{table_name}' table")
          note = "Note: You'll need to manually edit the migration file to "
          note += "specify the rename_column method"
          puts @pastel.yellow(note)
        end

        def generate_add_index_migration
          table_name = ask_for_table_name
          column_name = ask_for_column_name

          migration_name = "AddIndexTo#{table_name.capitalize}On#{column_name.capitalize}"
          command = "rails generate migration #{migration_name}"

          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Add index on '#{column_name}' column in '#{table_name}' table")
          puts @pastel.yellow("Note: You'll need to manually edit the migration file to specify the add_index method")

          execute_if_confirmed(command)
        end

        def generate_remove_index_migration
          table_name = ask_for_table_name
          column_name = ask_for_column_name

          migration_name = "RemoveIndexFrom#{table_name.capitalize}On#{column_name.capitalize}"
          command = "rails generate migration #{migration_name}"

          display_remove_index_summary(migration_name, column_name, table_name)
          execute_if_confirmed(command)
        end

        def display_remove_index_summary(migration_name, column_name, table_name)
          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Remove index on '#{column_name}' column from '#{table_name}' table")
          note = "Note: You'll need to manually edit the migration file to "
          note += "specify the remove_index method"
          puts @pastel.yellow(note)
        end

        def generate_custom_migration
          migration_name = ask_for_migration_name
          command = "rails generate migration #{migration_name}"
          display_custom_migration_summary(migration_name)
          execute_if_confirmed(command)
        end

        def ask_for_migration_name
          @prompt.ask(@pastel.cyan("Migration name:")) do |q|
            q.required true
            q.validate(/\A[A-Z][a-zA-Z0-9_]*\z/, "Migration name must be in PascalCase")
            q.modify :strip
          end
        end

        def display_custom_migration_summary(migration_name)
          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Create custom migration")
          note = "Note: You'll need to manually edit the migration file to "
          note += "add your custom logic"
          puts @pastel.yellow(note)
        end

        def ask_for_table_name
          @prompt.ask(@pastel.cyan("Table name:")) do |q|
            q.required true
            q.modify :strip
          end
        end

        def ask_for_column_name
          @prompt.ask(@pastel.cyan("Column name:")) do |q|
            q.required true
            q.modify :strip
          end
        end

        def ask_for_column_type
          @prompt.select(@pastel.cyan("Column type:")) do |menu|
            FIELD_TYPES.each { |type| menu.choice type }
            menu.choice "reference", "references"
          end
        end

        def collect_fields
          fields = []
          puts @pastel.cyan("\nAdd fields to your table (press Enter with empty name to finish):")

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

          field_type = ask_for_column_type
          build_field(field_name, field_type)
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

        def display_create_table_summary(migration_name, table_name, fields)
          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Create table '#{table_name}'")
          display_fields_table(fields)
        end

        def display_fields_table(fields)
          if fields.any?
            table = build_fields_table(fields)
            puts table.render(:unicode)
          else
            puts @pastel.yellow("No fields specified")
          end
        end

        def build_fields_table(fields)
          table = TTY::Table.new(header: ["Field Name", "Type", "Reference"])
          fields.each do |field|
            reference = field[:reference] || "-"
            table << [field[:name], field[:type], reference]
          end
          table
        end

        def execute_if_confirmed(command)
          if @prompt.yes?(@pastel.yellow("Generate this migration?"))
            execute_command(command)
          else
            puts @pastel.red("Migration generation cancelled.")
          end
        end

        def execute_command(command)
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
