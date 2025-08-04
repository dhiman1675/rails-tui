# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rails::Tui::Generator do
  let(:prompt) { instance_double(TTY::Prompt) }
  let(:pastel) { instance_double(Pastel) }
  
  before do
    allow(TTY::Prompt).to receive(:new).and_return(prompt)
    allow(Pastel).to receive(:new).and_return(pastel)
    allow(pastel).to receive(:cyan).and_return(pastel)
    allow(pastel).to receive(:bold).and_return("Rails TUI Generator")
    allow(pastel).to receive(:yellow).and_return(pastel)
    allow(pastel).to receive(:green).and_return(pastel)
    allow(pastel).to receive(:blue).and_return(pastel)
    allow(pastel).to receive(:magenta).and_return(pastel)
    allow(pastel).to receive(:red).and_return(pastel)
  end

  describe '#initialize' do
    it 'creates prompt and pastel instances' do
      expect(TTY::Prompt).to receive(:new)
      expect(Pastel).to receive(:new)
      
      described_class.new
    end
  end

  describe '#start' do
    subject { described_class.new }
    
    it 'displays welcome message and shows menu' do
      allow(prompt).to receive(:select).and_return('Exit')
      
      expect { subject.start }.to output(/Rails TUI Generator/).to_stdout
    end
  end
end
