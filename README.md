# Rails::Tui

[![Gem Version](https://badge.fury.io/rb/rails-tui.svg)](https://badge.fury.io/rb/rails-tui)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A beautiful Terminal User Interface (TUI) for generating Rails components interactively. Say goodbye to remembering complex Rails generator commands and hello to an intuitive, colorful, and interactive development experience!

## ✨ Features

- 🎨 **Beautiful Interactive Interface** - Colorful menus and prompts
- 📊 **Model Generator** - Create models with fields, types, and references
- 🎮 **Controller Generator** - Generate controllers with RESTful or custom actions
- 📝 **Migration Generator** - Create various types of migrations interactively
- 🔍 **Field Type Support** - All Rails field types including references
- ⚡ **Command Preview & Execution** - See the command before running it
- 🛡️ **Input Validation** - Smart validation for names and types
- 🎯 **Zero Configuration** - Works out of the box in any Rails project

## 📦 Installation

Add this line to your Rails application's Gemfile:

```ruby
gem 'rails-tui'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install rails-tui
```

## 🚀 Usage

Simply run the command in your Rails project directory:

```bash
$ bundle exec rails-tui
```

Or use the specific generate command:

```bash
$ bundle exec rails-tui generate
```

### Interactive Menu

You'll see a beautiful menu like this:

```
🚀 Rails TUI Generator
Interactive generator for Rails components

What would you like to generate?
‣ 📊 Model
  🎮 Controller
  📝 Migration
  ❌ Exit
```

## 📊 Model Generator

Generate models with interactive field selection:

1. **Select Model** from the menu
2. **Enter model name** (e.g., `User`, `BlogPost`)
3. **Add fields interactively:**
   - Field name: `name`
   - Field type: `string`
   - Field name: `email`
   - Field type: `string`
   - Field name: `age`
   - Field type: `integer`
   - Press Enter with empty name to finish
4. **Review the summary table**
5. **Generate and optionally execute**

### Supported Field Types

- `string`, `text`
- `integer`, `bigint`, `float`, `decimal`
- `boolean`
- `date`, `datetime`, `time`, `timestamp`
- `binary`
- `references` (with model selection)

### Example Output

```bash
📋 Model Summary:
Model: User
┌─────────────┬─────────┬───────────┐
│ Field Name  │ Type    │ Reference │
├─────────────┼─────────┼───────────┤
│ name        │ string  │ -         │
│ email       │ string  │ -         │
│ age         │ integer │ -         │
└─────────────┴─────────┴───────────┘

🚀 Generated Command:
rails generate model User name:string email:string age:integer
```

## 🎮 Controller Generator

Create controllers with RESTful or custom actions:

1. **Select Controller** from the menu
2. **Enter controller name** (e.g., `Users`, `BlogPosts`)
3. **Choose actions:**
   - Select common RESTful actions (index, show, new, create, edit, update, destroy)
   - Or pick specific actions
   - Add custom actions
4. **Review and generate**

### Example

```bash
📋 Controller Summary:
Controller: Users
Actions: index, show, new, create, edit, update, destroy, profile

🚀 Generated Command:
rails generate controller Users index show new create edit update destroy profile
```

## 📝 Migration Generator

Create various types of migrations:

### Migration Types

- **Create table** - New table with fields
- **Add column** - Add single column to existing table
- **Remove column** - Remove column from table
- **Change column** - Change column type
- **Rename column** - Rename existing column
- **Add index** - Add database index
- **Remove index** - Remove database index
- **Custom migration** - Empty migration for custom logic

### Example: Create Table Migration

```bash
📋 Migration Summary:
Migration: CreatePosts
Action: Create table 'posts'
┌─────────────┬─────────┬───────────┐
│ Field Name  │ Type    │ Reference │
├─────────────┼─────────┼───────────┤
│ title       │ string  │ -         │
│ content     │ text    │ -         │
│ user        │ references │ User   │
└─────────────┴─────────┴───────────┘

🚀 Generated Command:
rails generate migration CreatePosts title:string content:text user:references
```

## 🎯 Pro Tips

1. **Field References**: When you select `references` type, you'll be prompted for the model name
2. **Command Preview**: Always review the generated command before executing
3. **Multiple Components**: Generate multiple components in one session
4. **Empty Input**: Press Enter with empty input to finish adding fields/actions
5. **Exit Anytime**: Select "Exit" or press `Ctrl+C` to quit

## 🛠️ Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

### Local Development

For local development, add this to your test Rails app's Gemfile:

```ruby
gem 'rails-tui', path: '/path/to/your/local/rails-tui'
```

### Testing

```bash
# Run tests
$ bundle exec rspec

# Test the gem directly
$ bundle exec exe/rails-tui

# Run basic functionality test
$ ruby test_gem.rb
```

## 🤝 Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dhiman1675/rails-tui.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## 📄 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 🙏 Acknowledgments

- Built with [TTY toolkit](https://ttytoolkit.org/) for beautiful terminal interfaces
- Inspired by the need for better Rails development workflows
- Thanks to the Rails community for continuous inspiration

---

**Made with ❤️ by [Rohit Dhiman](https://github.com/dhiman1675)**

*Happy Rails coding! 🚂✨*
