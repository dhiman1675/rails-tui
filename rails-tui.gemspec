# frozen_string_literal: true

require_relative "lib/rails/tui/version"

Gem::Specification.new do |spec|
  spec.name = "rails-tui"
  spec.version = Rails::Tui::VERSION
  spec.authors = ["ROHIT DHIMAN"]
  spec.email = ["dhiman1675@gmail.com"]

  spec.summary = "A Terminal User Interface for generating Rails components"
  spec.description = "Rails TUI provides an interactive terminal interface to generate models, migrations, controllers, and other Rails components with ease."
  spec.homepage = "https://github.com/rohitdhiman/rails-tui"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rohitdhiman/rails-tui"
  spec.metadata["changelog_uri"] = "https://github.com/rohitdhiman/rails-tui/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies for TUI functionality
  spec.add_dependency "tty-prompt", "~> 0.23"
  spec.add_dependency "tty-table", "~> 0.12"
  spec.add_dependency "pastel", "~> 0.8"
  spec.add_dependency "thor", "~> 1.0"
  
  # Development dependencies
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
