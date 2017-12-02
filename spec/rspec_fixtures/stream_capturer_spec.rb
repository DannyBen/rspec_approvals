require 'spec_helper'

describe CaptureStdout do
  let(:proc) { Proc.new { print "hello world" } }

  it "captures stdout" do
    expect(CaptureStdout.capture proc).to eq "hello world"
  end
end

describe CaptureStderr do
  let(:proc) { Proc.new { $stderr.print "hello world" } }

  it "captures stdout" do
    expect(CaptureStderr.capture proc).to eq "hello world"
  end
end
