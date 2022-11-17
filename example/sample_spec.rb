require 'rspec'
require 'rspec_approvals'
require 'fileutils'

RSpec.configure { |c| c.approvals_path = 'example/approvals' }

describe 'interactivity' do
  subject { 'shiny approval' }

  context 'when a approval does not exist' do
    before do
      file = 'example/approvals/interactive1'
      FileUtils.rm_f file
    end

    it 'asks the user to approve the new content' do
      expect(subject).to match_approval('interactive1')
    end
  end

  context 'when the approval exists, but different' do
    before do
      File.write 'example/approvals/interactive2', 'old, wrinkled approval'
    end

    it 'shows the old and new versions to the user' do
      expect(subject).to match_approval('interactive2')
    end
  end
end

describe 'match_approval' do
  subject { 'this approval is a match' }

  it 'works' do
    expect(subject).to match_approval('match_approval')
  end

  context 'with diff' do
    subject { 'this approval is a ALMOST A match' }

    it 'works, despite the string being a little different' do
      expect(subject).to match_approval('match_approval').diff(9)
    end
  end
end

describe 'output_approval' do
  subject { puts 'this approval is an output' }

  it 'works' do
    expect { subject }.to output_approval('output_approval')
  end

  context 'with diff' do
    subject { puts 'this approval is a DIFFERENT output' }

    it 'works, despite the string being a little different' do
      expect { subject }.to output_approval('output_approval').diff(10)
    end
  end
end
