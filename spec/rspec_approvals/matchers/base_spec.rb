require 'spec_helper'

describe Matchers::Base do
  subject { described_class.new 'something' }

  describe '#diffable?' do
    it 'is true' do
      expect(subject.diffable?).to eq true
    end
  end

  describe '#matches?' do
    it 'sets @actual' do
      subject.matches? 'something'
      expect(subject.actual).to eq 'something'
    end

    context 'when actual matches expected' do
      it 'returns true' do
        expect(subject.matches? 'something').to be true
      end
    end

    context 'when actual does not match expected' do
      it 'returns false' do
        expect(subject.matches? 'something else').to be false
      end
    end

    context 'when the approval file does not exist' do
      subject { described_class.new 'no-such-approval' }

      context 'when actual is empty' do
        it 'returns false' do
          expect(subject.matches? '').to be false
        end
      end
    end

    context 'when strip_ansi_escape is on' do
      before :all do
        RSpec.configuration.strip_ansi_escape = true
      end

      after :all do
        RSpec.configuration.strip_ansi_escape = false
      end

      it 'removes ansi codes from the actual string' do
        subject.matches? "\e[33;44msomething\e[0m"
        expect(subject.actual).to eq 'something'
      end
    end

    context 'with .diff' do
      before do
        subject.diff 5
      end

      context 'when the strings are similar' do
        it 'returns true' do
          expect(subject.matches? 'something good').to be true
        end
      end

      context 'when the strings are not too similar' do
        it 'returns false' do
          expect(subject.matches? 'something completely different').to be false
        end
      end
    end

    context 'with .except' do
      subject { described_class.new 'except' }

      before do
        subject.except(/path: .*file.rb/)
      end

      context 'when the strings are similar' do
        it 'returns true' do
          expect(subject.matches? 'path: /mis/matched/file.rb').to be true
        end
      end

      context 'when the strings are not similar' do
        it 'returns false' do
          expect(subject.matches? 'path: /mis/matched/folder').to be false
        end
      end
    end

    context 'with .except and a replace argument' do
      subject { described_class.new 'except-replace' }

      before do
        subject.except(/^1.*9$/, '1...9')
      end

      context 'when the strings are similar' do
        it 'returns true' do
          expect(subject.matches? "1239\n1789").to be true
        end
      end

      context 'when the strings are not similar' do
        it 'returns false' do
          expect(subject.matches? "123\n789").to be false
        end
      end
    end

    context 'with .before' do
      before do
        subject.before ->(actual) { actual.sub 'any', 'some' }
      end

      context 'when the strings are similar' do
        it 'returns true' do
          expect(subject.matches? 'anything').to be true
        end
      end

      context 'when the strings are not similar' do
        it 'returns false' do
          expect(subject.matches? 'nothing').to be false
        end
      end
    end

    context 'when before_approval is set' do
      before :all do
        RSpec.configuration.before_approval = lambda { |actual|
          "MODIFIED #{actual} MODIFIED"
        }
      end

      after :all do
        RSpec.configuration.before_approval = nil
      end

      it 'sends the actual output to the proc before comparing' do
        subject.matches? 'something'
        expect(subject.actual).to eq 'MODIFIED something MODIFIED'
      end
    end
  end

  describe '#expected' do
    it 'loads approval content from a file' do
      expect(subject.expected).to eq File.read('spec/approvals/something')
    end
  end

  describe '#failure_message' do
    it 'returns a formatted string' do
      subject.matches? 'something else'
      expect(subject.failure_message).to eq "expected: something else\nto match: something"
    end

    context 'when using levenshtein' do
      it 'returns a message with actual and expected distance' do
        subject.diff 2
        subject.matches? 'something else'
        expect(subject.failure_message)
          .to eq "expected: something else\nto match: something\n(actual distance is 5 instead of the expected 2)"
      end
    end

    context 'when the actual string is empty' do
      subject { described_class.new 'no-such-approval' }

      it 'returns a proper message' do
        subject.matches? ''
        expect(subject.failure_message).to eq 'actual string is empty'
      end
    end
  end

  describe '#approval_file' do
    it 'returns a path' do
      expect(subject.approval_file).to eq "#{subject.approvals_dir}/#{subject.approval_name}"
    end
  end
end
