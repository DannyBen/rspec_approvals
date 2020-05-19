require 'spec_helper'

describe Stream::Stdout do
  let(:proc) { Proc.new { print "hello world" } }

  it "captures stdout" do
    expect(described_class.capture proc).to eq "hello world"
  end
end

describe Stream::Stderr do
  let(:proc) { Proc.new { $stderr.print "hello world" } }

  it "captures stdout" do
    expect(described_class.capture proc).to eq "hello world"
  end
end
