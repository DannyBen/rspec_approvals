module RSpecFixtures
  module Matchers
    # Adds the matcher to RSpec:
    # `expect { something_that_errors }.to raise_fixture(file)`
    def raise_fixture(expected)
      RaiseFixture.new expected
    end
    
    class RaiseFixture < Base
      # Called by RSpec
      def matches?(block)
        return false unless block.is_a? Proc
        @actual = 'Nothing raised'

        begin
          CaptureStdout.capture block
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