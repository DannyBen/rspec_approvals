require 'spec_helper'

describe Matchers::Base do
  subject { Matchers::Base.new 'something' }

  describe '#diffable?' do
    it "is true" do
      expect(subject.diffable?).to eq true
    end
  end

  describe '#matches?' do
    it "sets @actual" do
      subject.matches? 'something'
      expect(subject.actual).to eq 'something'
    end

    context "when actual matches expected" do
      it "returns true" do
        expect(subject.matches? 'something').to be true
      end
    end
    
    context "when actual does not match expected" do
      it "returns false" do
        expect(subject.matches? 'something else').to be false
      end
    end

    context "when using levenshtein" do
      before do
        subject.diff 5
      end

      context "when the strings are similar" do
        it "returns true" do
          expect(subject.matches? 'something good').to be true
        end
      end

      context "when the strings are not too similar" do
        it "returns false" do
          expect(subject.matches? 'something completely different').to be false
        end
      end
    end
  end

  describe '#expected' do
    it "loads fixture content from a file" do
      expect(subject.expected).to eq File.read('spec/fixtures/something')
    end
  end

  describe '#failure_message' do
    it "returns a formatted string" do
      subject.matches? 'something else'
      expect(subject.failure_message).to eq "expected: something else\nto match: something"
    end

    context "when using levenshtein" do
      it "returns a message with actual and expected distance" do
        subject.diff 2
        subject.matches? 'something else'
        expect(subject.failure_message).to eq "expected: something else\nto match: something\n(actual distance is 5 instead of the expected 2)"
      end      
    end
  end

  describe '#fixture_file' do
    it "returns a path" do
      expect(subject.fixture_file).to eq "#{subject.fixtures_dir}/#{subject.fixture_name}"
    end
  end

end
