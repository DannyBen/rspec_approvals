module RSpecApprovals
  module Matchers
    # Adds the matcher to RSpec:
    # `expect { something_that_errors }.to raise_approval(file)`
    def raise_approval(expected)
      RaiseApproval.new expected
    end
    
    class RaiseApproval < Base
      # Called by RSpec
      def matches?(block)
        return false unless block.is_a? Proc
        @actual = 'Nothing raised'

        begin
          block.call
        rescue => e
          @actual = e.inspect
        end

        super
      end

      # Lets RSpec know that this matcher requires a block.
      def supports_block_expectations?
        true
      end
    end
  end
end