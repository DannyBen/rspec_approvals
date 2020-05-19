require 'spec_helper'

describe Matchers::RaiseApproval do
  subject { Matchers::RaiseApproval.new 'raised' }

  describe '::raise_approval' do
    it "works" do
      expect{ raise "Something fakely went wrong" }.to raise_approval('raised')
    end

    context "when the block does not raise anything" do
      it "compares with 'Nothing raised'" do
        expect{ "not raising" }.to raise_approval('nothing-raised')
      end
    end
  end
end
