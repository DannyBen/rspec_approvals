require 'rspec'
require 'rspec_approvals'

describe 'something' do
  subject { "hello\n" }

  it 'works' do
    expect(subject).to match_approval 'sample'
  end
end
