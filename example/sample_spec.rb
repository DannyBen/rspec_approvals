require 'rspec'
require 'rspec_fixtures'

describe 'output_fixture' do
  subject { puts "hello world" }

  it "works" do
    expect{ subject }.to output_fixture("tmp/sample")
  end
end
