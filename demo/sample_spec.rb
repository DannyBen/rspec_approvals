require 'rspec'
require 'rspec_fixtures'

describe 'something' do
  subject { "hello\nworld\n" }

  it "works" do
    expect(subject).to match_fixture 'sample'
  end
end
  
