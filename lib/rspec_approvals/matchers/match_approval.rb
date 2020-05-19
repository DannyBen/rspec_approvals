require 'string-similarity'

module RSpecApprovals
  module Matchers
    # Adds the matcher to RSpec:
    # `expect(string).to match_approval(file)`
    def match_approval(expected)
      MatchApproval.new expected
    end
    
    class MatchApproval < Base
    end
    
  end
end