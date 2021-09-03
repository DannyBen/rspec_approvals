require 'strings-ansi'

module RSpecApprovals
  # Capture stdout and stderr
  #
  # These methods are borrowed from rspec's built in matchers
  # https://github.com/rspec/rspec-expectations/blob/add9b271ecb1d65f7da5bc8a9dd8c64d81d92303/lib/rspec/matchers/built_in/output.rb
  module Stream
    module Capture
      def self.capture(stream, block)
        RSpecApprovals.stdout.truncate 0
        RSpecApprovals.stdout.rewind
        RSpecApprovals.stderr.truncate 0
        RSpecApprovals.stderr.rewind

        stdout_original_stream = $stdout
        stderr_original_stream = $stderr
        $stdout = RSpecApprovals.stdout
        $stderr = RSpecApprovals.stderr
        block.call
        RSpecApprovals.send(stream).string.dup

      ensure
        $stdout = stdout_original_stream
        $stderr = stderr_original_stream

      end
    end

    module Stdout
      def self.capture(block)
        Capture.capture :stdout, block
      end
    end

    module Stderr
      def self.capture(block)
        Capture.capture :stderr, block
      end
    end
  end
end