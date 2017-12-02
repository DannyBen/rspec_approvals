require 'spec_helper'

describe Matchers::MatchFixture do
  subject { Matchers::MatchFixture.new 'something' }

  describe '::match_fixture' do
    it "works" do
      expect('anything').to match_fixture('anything')
    end
  end

  describe '#diffable?' do
    it "returns true" do
      expect(subject.diffable?).to eq true
    end
  end

  describe '#failure_message' do
    it "returns a formatted string" do
      subject.matches? 'something else'
      expect(subject.failure_message).to eq "expected something else\nto match something"
    end
  end

  describe '#matches?' do
    context "when interactive mode is enabled" do
      subject { Matchers::MatchFixture.new 'no_such_fixture' }

      before :all do 
        RSpec.configuration.interactive_fixtures = true
      end

      after :all do
        RSpec.configuration.interactive_fixtures = false
      end

      context "when fixture file does not exist" do
        let(:file) { 'spec/fixtures/no_such_fixture' }

        before do
          File.delete file if File.exist? file
          expect(File).not_to exist(file)
        end

        it "asks for approval and creates the fixture" do
          expect($stdin).to receive(:getch).and_return 'y'
          expect{ subject.matches? 'no_such_fixture' }.to output(/Approval Needed/).to_stdout
          expect(File).to exist(file)
        end

      end
    end
  end

end
