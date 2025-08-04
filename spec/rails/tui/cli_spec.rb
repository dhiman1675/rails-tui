# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rails::Tui::CLI do
  describe '#version' do
    it 'displays the version' do
      expect { subject.version }.to output("#{Rails::Tui::VERSION}\n").to_stdout
    end
  end

  describe '#generate' do
    it 'starts the generator' do
      generator = instance_double(Rails::Tui::Generator)
      expect(Rails::Tui::Generator).to receive(:new).and_return(generator)
      expect(generator).to receive(:start)
      
      subject.generate
    end
  end
end
