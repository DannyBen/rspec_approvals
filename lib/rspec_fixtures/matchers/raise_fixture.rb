module RSpecFixtures
  module Matchers
    # Adds the matcher to RSpec:
    # `expect{ stream }.to output_fixture(file)`
    def raise_fixture(type_or_name, name=nil)
      if name
        type = type_or_name
      else
        type = Exception
        name = type_or_name
      end

      RaiseFixture.new name, type
    end
    
    class RaiseFixture < Base
      attr_reader :exception_type

      def initialize(fixture_name, type=nil)
        @exception_type = type
        super fixture_name
      end

      # Called by RSpec
      def matches?(block)
        return false unless block.is_a? Proc
        @actual = 'Nothing raised'

        begin
          CaptureStdout.capture block
        rescue exception_type => e
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