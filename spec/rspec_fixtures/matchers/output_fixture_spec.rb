require 'spec_helper'

describe Matchers::OutputFixture do
  subject { Matchers::OutputFixture.new 'something' }

  describe '::output_fixture' do
    it "works" do
      expect{ print 'anything' }.to output_fixture('anything')
    end
  end

  describe '#matches?' do
    subject { Matchers::OutputFixture.new 'something' }

    context "when interactive mode is enabled" do
      before :all do 
        RSpec.configuration.interactive_fixtures = true
      end

      after :all do
        RSpec.configuration.interactive_fixtures = false
      end

      it "requests user approval" do
        expect(subject).to receive(:approve_fixture).and_return true
        expect(subject.matches? Proc.new { puts 'nothing' } ).to be true
      end
    end
  end

  describe '#to_stdout' do
    it "sets @stream_capturer to CaotureStdout" do
      expect(subject.to_stdout.stream_capturer).to be CaptureStdout
    end
  end

  describe '#to_stderr' do
    it "sets @stream_capturer to CaotureStderr" do
      expect(subject.to_stderr.stream_capturer).to be CaptureStderr
    end
  end

end
