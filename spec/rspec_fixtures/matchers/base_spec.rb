require 'spec_helper'

describe Matchers::Base do
  subject { Matchers::Base.new 'something' }

  describe '#diffable?' do
    it "is true" do
      expect(subject.diffable?).to eq true
    end
  end

  describe '#matches?' do
    it "returns true when actual matches expected" do
      expect(subject.matches? 'something').to be true
    end
    
    it "returns false when actual does not match expected" do
      expect(subject.matches? 'something else').to be false
    end

    it "sets @actual" do
      subject.matches? 'something'
      expect(subject.actual).to eq 'something'
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
  end

  describe '#fixture_file' do
    it "returns a path" do
      expect(subject.fixture_file).to eq "#{subject.fixtures_dir}/#{subject.fixture_name}"
    end
  end

end
