require 'spec_helper'

describe ApprovalHandler do
  let(:approval) { 'spec/approvals/approval_handler' }

  def user_response(response)
    expect_any_instance_of(ApprovalHandler).to receive(:user_response).and_return response
  end

  describe '#run' do
    context 'when the approval file does not exist' do
      before { FileUtils.rm_f approval }
      let(:base_menu_options) do
        {
          'a' => ['Approve (and save)', :approve],
          'r' => ['Reject (and fail test)', :reject],
        }
      end

      it 'only asks the user to Approve or Reject' do
        expect(Prompt).to receive(:select)
          .with('Please Choose:', 'r', base_menu_options)
          .and_return('Reject')

        expect { subject.run '', 'actual', approval }
          .to output(/actual/).to_stdout
      end

      context 'when the user answers Approve' do
        before { user_response :approve }

        it 'writes actual result to approval and reutrns true' do
          supress_output do
            expect(subject.run 'expected', 'actual', approval).to be true
          end
          expect(File.read approval).to eq 'actual'
        end

        context 'when the approval folders do not exist' do
          it 'creates them using deep_write' do
            expect(File).to receive(:deep_write).with('some/deep/path', 'actual')
            supress_output do
              subject.run 'expected', 'actual', 'some/deep/path'
            end
          end
        end
      end

      context 'when the user answers Reject' do
        before { user_response :reject }

        it 'does not write to approval and returns false' do
          supress_output do
            expect(subject.run 'expected', 'actual', approval).to be false
          end
          expect(File).not_to exist approval
        end
      end

      context 'when the user answers something unexpected' do
        before do
          user_response :no_such_response
        end

        it 'acts as Reject' do
          supress_output do
            expect(subject.run 'expected', 'actual', approval).to be false
          end
          expect(File).not_to exist approval
        end
      end

      context 'when auto_approve is configured to true' do
        before { RSpec.configuration.auto_approve = true }
        after  { RSpec.configuration.auto_approve = false }

        it 'does not prompt the user for approval' do
          expect(subject).not_to receive(:user_response)
          supress_output do
            expect(subject.run 'expected', 'actual', approval).to be true
          end
          expect(File.read approval).to eq 'actual'
        end
      end
    end

    context 'when the approval file exists' do
      before { File.write approval, 'expected output' }

      context 'when the user answers Show Actual' do
        before do
          user_response :actual
          user_response :approve
        end

        it 'shows the actual output' do
          expect { subject.run 'expected output', 'actual output', approval }
            .to output(/actual output/).to_stdout
        end
      end

      context 'when the user answers Show Expected' do
        before do
          user_response :expected
          user_response :approve
        end

        it 'shows the expected approval' do
          expect { subject.run 'expected output', 'actual output', approval }
            .to output(/expected output/).to_stdout
        end
      end

      context 'when the user answers Show Diff' do
        before do
          user_response :diff
          user_response :approve
        end

        it 'shows the diff' do
          expect { subject.run 'expected output', 'actual output', approval }
            .to output(/-expected output.*\+actual output/m).to_stdout
        end
      end
    end
  end
end
