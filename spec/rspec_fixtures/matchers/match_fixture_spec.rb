require 'spec_helper'

describe Matchers::MatchFixture do
  describe '#diffable?' do
    it "returns true" do
      expect(subject.diffable?).to eq true
    end
  end

  describe '#failure_message' do
    subject { Matchers::MatchFixture.new 'something' }

    it "returns a formatted string" do
      subject.matches? 'something else'
      expect(subject.failure_message).to eq "expected something\nto match something else"
    end
  end

  describe '#match_fixture' do
    it "works" do
      expect('anything').to match_fixture('anything')
    end

    context "when interactive mode is enabled" do
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

        it "asks for approval and saves the fixture" do
          expect($stdin).to receive(:getch).and_return 'y'
          expect {
            expect('anything').to match_fixture('no_such_fixture') 
          }.to output(/Approval Needed/).to_stdout
          expect(File).to exist(file)
        end
      end

      context "when fixture file exists but wrong" do
        let(:file) { 'spec/fixtures/apples' }

        before do
          File.write file, 'apples'
        end

        it "asks for approval and updates the fixture" do
          expect($stdin).to receive(:getch).and_return 'y'
          expect {
            expect('oranges').to match_fixture('apples') 
          }.to output(/Approval Needed/).to_stdout
          expect(File.read file).to eq 'oranges'
        end
      end

      context "when rejecting approval" do
        let(:file) { 'spec/fixtures/no_such_fixture' }

        before do
          File.delete file if File.exist? file
          expect(File).not_to exist(file)
        end

        it "fails the test" do
          expect($stdin).to receive(:getch).and_return 'n'
          expect {
            expect('anything').not_to match_fixture('no_such_fixture') 
          }.to output(/Approval Needed/).to_stdout
        end
      end
    end
  end
end
