require 'io/console'
require 'colsole'
require 'diffy'

module RSpecApprovals
  # Handles user input and interactive approvals
  class ApprovalHandler
    include Colsole

    attr_reader :expected, :actual, :approval_file

    def run(expected, actual, approval_file)
      @expected = expected
      @actual = actual
      @approval_file = approval_file

      show expected.empty? ? actual : diff
      prompt_user
    end

  private

    def prompt_user
      response = auto_approve? ? :approve : user_response

      case response

      when :approve, :reject
        send response

      when :actual, :expected, :diff
        show send response
        prompt_user

      else
        false

      end
    end

    def auto_approve?
      RSpec.configuration.auto_approve
    end

    def user_response
      Prompt.select 'Please Choose:', 'r', menu_options
    end

    def menu_options
      base = {
        'a' => ['Approve (and save)', :approve],
        'r' => ['Reject (and fail test)', :reject],
      }

      extra = {
        '1' => ['Show actual output', :actual],
        '2' => ['Show expected output', :expected],
        '3' => ['Show diff', :diff],
      }

      expected.empty? ? base : base.merge(extra)
    end

    def approve
      say 'g`Approved`'
      File.deep_write approval_file, actual
      true
    end

    def reject
      say 'r`Not Approved`'
      false
    end

    def separator
      "g`#{'_' * terminal_width}`"
    end

    def diff
      Diffy::Diff.new(expected, actual, context: 2).to_s :color
    end

    def show(what)
      say ''
      say separator
      say what
      say separator
    end
  end
end
