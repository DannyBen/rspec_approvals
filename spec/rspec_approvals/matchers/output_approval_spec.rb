require 'spec_helper'

describe Matchers::OutputApproval do
  subject { Matchers::OutputApproval.new 'something' }

  describe '::output_approval' do
    it 'works' do
      expect { print 'anything' }.to output_approval('anything')
    end
  end

  describe '#description' do
    it 'returns a description' do
      subject.matches? 'something else'
      expect(subject.description).to eq 'output approval "something"'
    end
  end

  describe '#matches?' do
    context 'when interactive mode is enabled' do
      before :all do
        RSpec.configuration.interactive_approvals = true
      end

      after :all do
        RSpec.configuration.interactive_approvals = false
      end

      it 'requests user approval' do
        expect(subject).to receive(:approve_approval).and_return true
        expect(subject.matches? proc { puts 'nothing' }).to be true
      end
    end
  end

  describe '#to_stdout' do
    it 'sets @stream_capturer to CaotureStdout' do
      expect(subject.to_stdout.stream_capturer).to be Stream::Stdout
    end
  end

  describe '#to_stderr' do
    it 'sets @stream_capturer to CaotureStderr' do
      expect(subject.to_stderr.stream_capturer).to be Stream::Stderr
    end
  end
end
