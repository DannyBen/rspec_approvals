require 'spec_helper'

describe File do
  subject { described_class }

  describe '::deep_write' do
    let(:file) { 'spec/tmp/subfolder/filename' }
    let(:dir) { subject.dirname file }

    before do
      subject.delete file if subject.exist? file
      Dir.delete dir if Dir.exist? dir
      expect(subject).not_to exist file
      expect(Dir).not_to exist dir
    end

    it 'writes to a file and creates parent folders' do
      subject.deep_write file, 'content'
      expect(subject).to exist file
      expect(subject.read file).to eq 'content'
    end
  end
end
