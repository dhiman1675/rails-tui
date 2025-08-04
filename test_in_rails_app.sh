#!/bin/bash

# Script to test rails-tui gem in a real Rails application

echo "🚀 Creating test Rails application..."

# Create a temporary directory for testing
mkdir -p /tmp/rails-tui-test
cd /tmp/rails-tui-test

# Create a new Rails app
rails new test_app --skip-git --skip-bundle
cd test_app

# Add our gem to the Gemfile
echo "" >> Gemfile
echo "# Local gem for testing" >> Gemfile
echo "gem 'rails-tui', path: '/home/jon/projects/rails-tui'" >> Gemfile

# Install dependencies
bundle install

echo ""
echo "✅ Test Rails app created!"
echo "📍 Location: /tmp/rails-tui-test/test_app"
echo ""
echo "To test the gem in this Rails app:"
echo "  cd /tmp/rails-tui-test/test_app"
echo "  bundle exec rails-tui"
echo ""
echo "Or test specific commands:"
echo "  bundle exec rails-tui generate"
echo "  bundle exec rails-tui version"
