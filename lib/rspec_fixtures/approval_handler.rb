require 'colsole'

module RSpecFixtures
  class ApprovalHandler
    include Colsole

    def run(expected, actual, fixture_file)
      line = '_' * terminal_width

      say "!txtgrn!#{line}"
      if expected.empty?
        say actual
      else
        say "> New (Actual):"
        say actual
        say "!txtpur!#{line}"
        say "> Old (Fixture):"
        say expected
      end
      say "!txtgrn!#{line}"
      say "> Approve new fixture? (y/N): "
      
      if user_approves?
        say "!txtgrn!Approved"
        File.deep_write fixture_file, actual
        true
      else
        say "!txtred!Not Approved"
        false
      end
    end

    private

    def user_approves?
      # NOTE: getc does not work, therefore using gets
      #       See: https://stackoverflow.com/questions/48459605/ruby-2-5-0-stdin-getc-does-not-work-on-consecutive-calls
      $stdin.gets =~ /^[Yy]/
    end
  end
end