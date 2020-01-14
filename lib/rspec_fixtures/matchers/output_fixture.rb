module RSpecFixtures
  module Matchers
    # Adds the matcher to RSpec:
    # `expect { stream }.to output_fixture(file)`
    def output_fixture(expected)
      OutputFixture.new expected
    end
    
    class OutputFixture < Base
      # Called by RSpec
      def matches?(block)
        return false unless block.is_a? Proc
        @actual = stream_capturer.capture block
        super
      end

      # Lets RSpec know that this matcher requires a block.
      def supports_block_expectations?
        true
      end

      # Adds chained matcher, to allow:
      # expect{ stream }.to output_fixture(file).to_stdout
      # This is the default, and only provided for completeness.
      def to_stdout
        @stream_capturer = Stream::Stdout
        self
      end

      # Adds chained matcher, to allow:
      # expect{ stream }.to output_fixture(file).to_stderr
      def to_stderr
        @stream_capturer = Stream::Stderr
        self
      end

      def stream_capturer
        @stream_capturer ||= Stream::Stdout
      end

    end
  end
end