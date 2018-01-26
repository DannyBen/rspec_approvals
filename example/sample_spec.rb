require 'rspec'
require 'rspec_fixtures'
require "fileutils"

RSpec.configure { |c| c.fixtures_path = 'example/fixtures' }

describe 'interactivity' do
  subject { "shiny fixture" }

  context 'when a fixture does not exist' do
    before do
      file = 'example/fixtures/interactive1'
      FileUtils.rm file if File.exist? file
    end

    it 'asks the user to approve the new content' do
      expect(subject).to match_fixture('interactive1')
    end
  end

  context 'when the fixture exists, but different' do
    before do
      File.write 'example/fixtures/interactive2', 'old, wrinkled fixture'
    end

    it 'shows the old and new versions to the user' do
      expect(subject).to match_fixture('interactive2')
    end
  end
end

describe 'match_fixture' do
  subject { "this fixture is a match" }

  it "works" do
    expect(subject).to match_fixture("match_fixture")
  end
end

describe 'output_fixture' do
  subject { puts "this fixture is an output" }

  it "works" do
    expect{ subject }.to output_fixture("output_fixture")
  end
end
