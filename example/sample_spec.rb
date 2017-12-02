require 'rspec'
require 'rspec_fixtures'

describe 'something' do
  subject { puts "hello world" }

  it "should work" do
    expect{ subject }.to output_fixture("command")
  end
end
