# frozen_string_literal: true

require 'tty-table'

module Rails
  module Tui
    module Generators
      class MigrationGenerator
        MIGRATION_TYPES = [
          'Create table',
          'Add column',
          'Remove column',
          'Change column',
          'Rename column',
          'Add index',
          'Remove index',
          'Custom migration'
        ].freeze
        
        FIELD_TYPES = %w[string text integer bigint float decimal boolean date datetime time timestamp binary].freeze
        
        def initialize(prompt, pastel)
          @prompt = prompt
          @pastel = pastel
        end

        def generate
          puts @pastel.magenta.bold("\n📝 Migration Generator")
          
          migration_type = select_migration_type
          
          case migration_type
          when 'Create table'
            generate_create_table_migration
          when 'Add column'
            generate_add_column_migration
          when 'Remove column'
            generate_remove_column_migration
          when 'Change column'
            generate_change_column_migration
          when 'Rename column'
            generate_rename_column_migration
          when 'Add index'
            generate_add_index_migration
          when 'Remove index'
            generate_remove_index_migration
          when 'Custom migration'
            generate_custom_migration
          end
        end

        private

        def select_migration_type
          @prompt.select(@pastel.cyan("What type of migration?")) do |menu|
            MIGRATION_TYPES.each { |type| menu.choice type }
          end
        end

        def generate_create_table_migration
          table_name = get_table_name
          fields = collect_fields
          
          migration_name = "Create#{table_name.capitalize}"
          
          display_create_table_summary(migration_name, table_name, fields)
          
          if @prompt.yes?(@pastel.yellow("Generate this migration?"))
            command_parts = ["rails generate migration #{migration_name}"]
            
            fields.each do |field|
              if field[:type] == "references"
                command_parts << "#{field[:name]}:references"
              else
                command_parts << "#{field[:name]}:#{field[:type]}"
              end
            end
            
            execute_command(command_parts.join(" "))
          end
        end

        def generate_add_column_migration
          table_name = get_table_name
          column_name = get_column_name
          column_type = get_column_type
          
          migration_name = "Add#{column_name.capitalize}To#{table_name.capitalize}"
          command = "rails generate migration #{migration_name} #{column_name}:#{column_type}"
          
          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Add column '#{column_name}' (#{column_type}) to '#{table_name}' table")
          
          execute_if_confirmed(command)
        end

        def generate_remove_column_migration
          table_name = get_table_name
          column_name = get_column_name
          
          migration_name = "Remove#{column_name.capitalize}From#{table_name.capitalize}"
          command = "rails generate migration #{migration_name} #{column_name}"
          
          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Remove column '#{column_name}' from '#{table_name}' table")
          
          execute_if_confirmed(command)
        end

        def generate_change_column_migration
          table_name = get_table_name
          column_name = get_column_name
          new_type = get_column_type
          
          migration_name = "Change#{column_name.capitalize}In#{table_name.capitalize}"
          command = "rails generate migration #{migration_name}"
          
          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Change column '#{column_name}' to type '#{new_type}' in '#{table_name}' table")
          puts @pastel.yellow("Note: You'll need to manually edit the migration file to specify the change_column method")
          
          execute_if_confirmed(command)
        end

        def generate_rename_column_migration
          table_name = get_table_name
          old_name = @prompt.ask(@pastel.cyan("Current column name:")) { |q| q.required true; q.modify :strip }
          new_name = @prompt.ask(@pastel.cyan("New column name:")) { |q| q.required true; q.modify :strip }
          
          migration_name = "Rename#{old_name.capitalize}To#{new_name.capitalize}In#{table_name.capitalize}"
          command = "rails generate migration #{migration_name}"
          
          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Rename column '#{old_name}' to '#{new_name}' in '#{table_name}' table")
          puts @pastel.yellow("Note: You'll need to manually edit the migration file to specify the rename_column method")
          
          execute_if_confirmed(command)
        end

        def generate_add_index_migration
          table_name = get_table_name
          column_name = get_column_name
          
          migration_name = "AddIndexTo#{table_name.capitalize}On#{column_name.capitalize}"
          command = "rails generate migration #{migration_name}"
          
          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Add index on '#{column_name}' column in '#{table_name}' table")
          puts @pastel.yellow("Note: You'll need to manually edit the migration file to specify the add_index method")
          
          execute_if_confirmed(command)
        end

        def generate_remove_index_migration
          table_name = get_table_name
          column_name = get_column_name
          
          migration_name = "RemoveIndexFrom#{table_name.capitalize}On#{column_name.capitalize}"
          command = "rails generate migration #{migration_name}"
          
          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Remove index on '#{column_name}' column from '#{table_name}' table")
          puts @pastel.yellow("Note: You'll need to manually edit the migration file to specify the remove_index method")
          
          execute_if_confirmed(command)
        end

        def generate_custom_migration
          migration_name = @prompt.ask(@pastel.cyan("Migration name:")) do |q|
            q.required true
            q.validate(/\A[A-Z][a-zA-Z0-9_]*\z/, "Migration name must be in PascalCase")
            q.modify :strip
          end
          
          command = "rails generate migration #{migration_name}"
          
          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Create custom migration")
          puts @pastel.yellow("Note: You'll need to manually edit the migration file to add your custom logic")
          
          execute_if_confirmed(command)
        end

        def get_table_name
          @prompt.ask(@pastel.cyan("Table name:")) do |q|
            q.required true
            q.modify :strip
          end
        end

        def get_column_name
          @prompt.ask(@pastel.cyan("Column name:")) do |q|
            q.required true
            q.modify :strip
          end
        end

        def get_column_type
          @prompt.select(@pastel.cyan("Column type:")) do |menu|
            FIELD_TYPES.each { |type| menu.choice type }
            menu.choice "reference", "references"
          end
        end

        def collect_fields
          fields = []
          
          puts @pastel.cyan("\nAdd fields to your table (press Enter with empty name to finish):")
          
          loop do
            field_name = @prompt.ask(@pastel.yellow("Field name:")) do |q|
              q.modify :strip
            end
            
            break if field_name.nil? || field_name.empty?
            
            field_type = get_column_type
            
            if field_type == "references"
              reference_model = @prompt.ask(@pastel.yellow("Reference model name:")) do |q|
                q.required true
                q.modify :strip
              end
              fields << { name: field_name, type: "references", reference: reference_model }
            else
              fields << { name: field_name, type: field_type }
            end
          end
          
          fields
        end

        def display_create_table_summary(migration_name, table_name, fields)
          puts @pastel.cyan.bold("\n📋 Migration Summary:")
          puts @pastel.white("Migration: #{migration_name}")
          puts @pastel.white("Action: Create table '#{table_name}'")
          
          if fields.any?
            table = TTY::Table.new(header: ['Field Name', 'Type', 'Reference'])
            
            fields.each do |field|
              reference = field[:reference] || '-'
              table << [field[:name], field[:type], reference]
            end
            
            puts table.render(:unicode)
          else
            puts @pastel.yellow("No fields specified")
          end
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
