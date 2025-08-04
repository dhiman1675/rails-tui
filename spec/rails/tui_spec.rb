# frozen_string_literal: true

RSpec.describe Rails::Tui do
  it "has a version number" do
    expect(Rails::Tui::VERSION).not_to be nil
  end

  it "has CLI and Generator classes available" do
    expect(Rails::Tui::CLI).to be_a(Class)
    expect(Rails::Tui::Generator).to be_a(Class)
  end
end
