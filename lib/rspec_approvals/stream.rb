require 'strings-ansi'

module RSpecApprovals
  # Capture stdout and stderr
  #
  # These methods are borrowed from rspec's built in matchers
  # https://github.com/rspec/rspec-expectations/blob/add9b271ecb1d65f7da5bc8a9dd8c64d81d92303/lib/rspec/matchers/built_in/output.rb
  module Stream
    module Stdout
      def self.capture(block)
        RSpecApprovals.stdout.truncate 0
        RSpecApprovals.stdout.rewind

        original_stream = $stdout
        $stdout = RSpecApprovals.stdout
        block.call
        RSpecApprovals.stdout.string.dup

      ensure
        $stdout = original_stream

      end
    end

    module Stderr
      def self.capture(block)
        RSpecApprovals.stderr.truncate 0
        RSpecApprovals.stderr.rewind

        original_stream = $stderr
        $stderr = RSpecApprovals.stderr
        block.call
        RSpecApprovals.stderr.string.dup

      ensure
        $stderr = original_stream

      end
    end
  end
end