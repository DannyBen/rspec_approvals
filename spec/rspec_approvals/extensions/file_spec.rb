require 'spec_helper'

describe File do
  describe '::deep_write' do
    let(:file) { 'spec/tmp/subfolder/filename' }
    let(:dir) { File.dirname file }

    before do
      FileUtils.rm_f file
      FileUtils.rm_f dir
      expect(File).not_to exist file
      expect(Dir).not_to exist dir
    end

    it 'writes to a file and creates parent folders' do
      File.deep_write file, 'content'
      expect(File).to exist file
      expect(File.read file).to eq 'content'
    end
  end
end
