#!/usr/bin/env ruby
# frozen_string_literal: true

# Test script for Rails TUI gem
require_relative "lib/rails/tui"

puts "Testing Rails TUI Gem..."
puts "========================"

begin
  # Test version
  puts "Version: #{Rails::Tui::VERSION}"

  # Test CLI initialization
  cli = Rails::Tui::CLI.new
  puts "✅ CLI class loads successfully: #{cli.class}"

  # Test Generator initialization
  generator = Rails::Tui::Generator.new
  puts "✅ Generator class loads successfully: #{generator.class}"

  puts "\n🎉 All basic tests passed!"
  puts "\nTo test interactively, run:"
  puts "  bundle exec exe/rails-tui"
rescue StandardError => e
  puts "❌ Error: #{e.message}"
  puts e.backtrace
end
