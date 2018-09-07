require 'spec_helper'

describe ApprovalHandler do
  let(:fixture) { 'spec/fixtures/approval_handler' }

  def user_response(response)
    expect_any_instance_of(ApprovalHandler).to receive(:get_response).and_return response
  end

  describe '#run' do
    context "when the fixture file does not exist" do
      before { File.delete fixture if File.exist? fixture }

      it "only asks the user to Approve or Reject" do
        # Check that evern after going down twice, we still remain at Approve
        stdin_send down_arrow, down_arrow, "\n" do
          expect{ subject.run 'expected', 'actual', fixture }.to output(/Approved/).to_stdout
        end
      end

      context "when the user answers Approve" do
        before { user_response :approve }

        it "writes actual result to fixture and reutrns true" do
          supress_output do
            expect(subject.run 'expected', 'actual', fixture).to be true
          end
          expect(File.read fixture).to eq 'actual'
        end

        context "when the fixture folders do not exist" do
          it "creates them using deep_write" do
            expect(File).to receive(:deep_write).with('some/deep/path', 'actual')
            supress_output do
              subject.run 'expected', 'actual', 'some/deep/path'
            end
          end
        end
      end

      context "when the user answers Reject" do
        before { user_response :reject }

        it "does not write to fixture and returns false" do
          supress_output do
            expect(subject.run 'expected', 'actual', fixture).to be false
          end
          expect(File).not_to exist fixture
        end      
      end

      context "when the user answers something unexpected" do
        before do
          user_response :no_such_response
        end

        it "acts as Reject" do
          supress_output do
            expect(subject.run 'expected', 'actual', fixture).to be false
          end
          expect(File).not_to exist fixture
        end      
      end

    end

    context "when the fixture file exists" do
      before { File.write fixture, 'expected output' }

      context "when the user answers Show Actual" do
        before do
          user_response :actual
          user_response :approve
        end

        it "shows the actual output" do
          expect{ subject.run 'expected output', 'actual output', fixture }.to output(/actual output/).to_stdout
        end
      end

      context "when the user answers Show Expected" do
        before do
          user_response :expected
          user_response :approve
        end

        it "shows the expected fixture" do
          expect{ subject.run 'expected output', 'actual output', fixture }.to output(/expected output/).to_stdout
        end
      end

      context "when the user answers Show Diff" do
        before do
          user_response :diff
          user_response :approve
        end

        it "shows the diff" do
          expect{ subject.run 'expected output', 'actual output', fixture }.to output(/-expected output.*\+actual output/m).to_stdout
        end
      end
    end
  end

end