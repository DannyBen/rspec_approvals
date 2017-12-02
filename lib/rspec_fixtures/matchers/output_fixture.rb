module RSpecFixtures
  module Matchers
    def output_fixture(expected)
      OutputFixture.new expected
    end
    
    class OutputFixture < Base
      def matches?(block)
        return false unless block.is_a? Proc
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

      def stream_capturer
        @stream_capturer ||= CaptureStdout
      end

    end
  end
end