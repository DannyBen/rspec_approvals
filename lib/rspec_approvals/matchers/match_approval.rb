require 'string-similarity'

module RSpecApprovals
  module Matchers
    # Adds the matcher to RSpec:
    # `expect(string).to match_approval(file)`
    def match_approval(expected)
      MatchApproval.new expected
    end

    class MatchApproval < Base
      def description
        %[match approval "#{approval_name}"]
      end
    end
  end
end
