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
    context "when actual == expected" do
      it "returns true" do
        expect(subject.matches? 'something').to be true
      end
    end

    context "when actual != expected" do
      it "returns false" do
        expect(subject.matches? 'something else').to be false
      end
    end

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

        it "asks for approval and returns true" do
          expect($stdin).to receive(:getch).and_return 'y'
          supress_output do
            expect(subject.matches? 'no_such_fixture').to be true
          end
          expect(File).to exist(file)
        end
      end

      context "when fixture file exists but wrong" do
        let(:file) { 'spec/fixtures/apples' }
        subject { Matchers::MatchFixture.new 'apples' }

        before do
          File.write file, 'apples'
        end

        it "asks for approval and updates the fixture" do
          expect($stdin).to receive(:getch).and_return 'y'
          supress_output do
            expect(subject.matches? 'oranges').to be true
          end
          expect(File.read file).to eq 'oranges'
        end
      end

      context "when rejecting approval" do
        let(:file) { 'spec/fixtures/no_such_fixture' }
        subject { Matchers::MatchFixture.new 'no_such_fixture' }

        before do
          File.delete file if File.exist? file
          expect(File).not_to exist(file)
        end

        it "fails the test" do
          expect($stdin).to receive(:getch).and_return 'n'
          supress_output do
            expect(subject.matches? 'anything').to be false
          end
        end
      end
    end
  end
end
