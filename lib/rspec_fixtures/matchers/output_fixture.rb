module RSpecFixtures
  module Matchers
    def output_fixture(expected)
      OutputFixture.new expected
    end
    
    class OutputFixture < Base
      attr_reader :stream_capturer

      def matches?(block)
        return false unless block.is_a? Proc
        @stream_capturer ||= CaptureStdout
        @actual = stream_capturer.capture block

        if actual == expected or !interactive?
          actual == expected
        else
          approve_fixture
        end
      end

      def supports_block_expectations?
        true
      end

      def to_stdout
        @stream_capturer = CaptureStdout
        self
      end

      def to_stderr
        @stream_capturer = CaptureStderr
        self
      end

    end
  end
end