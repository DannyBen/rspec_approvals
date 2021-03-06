require 'spec_helper'

describe Matchers::MatchApproval do
  subject { Matchers::MatchApproval.new 'something' }

  describe '::match_approval' do
    it "works" do
      expect('anything').to match_approval('anything')
    end
  end

  describe '#diffable?' do
    it "returns true" do
      expect(subject.diffable?).to eq true
    end
  end

  describe '#failure_message' do
    it "returns a formatted string" do
      subject.matches? 'something else'
      expect(subject.failure_message).to eq "expected: something else\nto match: something"
    end
  end

  describe '#matches?' do
    context "when interactive mode is enabled" do
      subject { Matchers::MatchApproval.new 'no_such_approval' }

      before :all do 
        RSpec.configuration.interactive_approvals = true
      end

      after :all do
        RSpec.configuration.interactive_approvals = false
      end

      context "when approval file does not exist" do
        let(:file) { 'spec/approvals/no_such_approval' }

        before do
          File.delete file if File.exist? file
          expect(File).not_to exist(file)
        end

        it "asks for approval and creates the approval" do
          expect_any_instance_of(ApprovalHandler).to receive(:get_response).and_return :approve
          expect{ subject.matches? 'no_such_approval' }.to output(/no_such_approval/).to_stdout
          expect(File).to exist(file)
        end

      end
    end
  end

end
