require 'spec_helper'

describe Prompt do
  subject { described_class }
  let(:options) { { '1' => ['Hello', :hello], '2' => ['World', :world] } }
  let(:default) { '2' }
  let(:prompt) { 'Choose:' }

  describe '::select' do
    it 'prints a menu and waits for keystroke' do
      expect($stdin).to receive(:getch).and_return '1'
      expect { subject.select prompt, default, options }
        .to output("1) Hello\n2) World\n\nChoose: \nHello\n").to_stdout
    end

    context 'when an unknown key is pressed' do
      it 'returns the default' do
        expect($stdin).to receive(:getch).and_return 'x'
        expect { subject.select prompt, default, options }
          .to output("1) Hello\n2) World\n\nChoose: \nWorld\n").to_stdout
      end
    end
  end
end
