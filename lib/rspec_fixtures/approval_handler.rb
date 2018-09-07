require 'io/console'
require 'colsole'
require 'tty-prompt'
require 'diffy'

module RSpecFixtures

  # Handles user input and interactive fixture approvals
  class ApprovalHandler
    include Colsole

    attr_reader :expected, :actual, :fixture_file

    def run(expected, actual, fixture_file)
      @expected = expected
      @actual = actual
      @fixture_file = fixture_file

      show expected.empty? ? actual : diff
      prompt_user
    end

    private

    def prompt_user
      response = prompt.select "Please Choose:", menu_options, marker: '>'

      case response
      when :approve
        approve
      
      when :reject
        reject
      
      when :actual
        show actual
        prompt_user
      
      when :expected
        show expected
        prompt_user

      when :diff
        show diff
        prompt_user

      
      else
        false
      
      end
    end

    def menu_options
      base = {
        'Reject (and fail test)' => :reject,
        'Approve (and save fixture)' => :approve,
      }

      extra = {
        'Show actual output' => :actual,
        'Show expected fixture' => :expected,
        'Show diff' => :diff,
      }

      expected.empty? ? base : base.merge(extra) 
    end

    def approve
      say "!txtgrn!Approved"
      File.deep_write fixture_file, actual
      true
    end

    def reject
      say "!txtred!Not Approved"
      false
    end

    def separator
      "!txtgrn!" + ('_' * terminal_width)
    end

    def diff
      Diffy::Diff.new(expected, actual).to_s :color
    end

    def show(what)
      say separator
      say what
      say separator
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end