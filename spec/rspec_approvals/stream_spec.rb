require 'spec_helper'

describe Stream do
  let(:output) do
    Proc.new do
      print "this is stdOUT"
      $stderr.print "this is stdERR"
    end
  end

  describe Stream::Stdout do
    it "captures stdout" do
      expect(described_class.capture output).to eq "this is stdOUT"
    end
  end
  
  describe Stream::Stderr do
    it "captures stderr" do
      expect(described_class.capture output).to eq "this is stdERR"
    end
  end
end
