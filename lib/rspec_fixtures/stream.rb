require 'strings-ansi'

module RSpecFixtures
  # Capture stdout and stderr
  #
  # These methods are borrowed from rspec's built in matchers
  # https://github.com/rspec/rspec-expectations/blob/add9b271ecb1d65f7da5bc8a9dd8c64d81d92303/lib/rspec/matchers/built_in/output.rb
  module Stream
    module Stdout
      def self.capture(block)
        RSpecFixtures.stdout.truncate 0
        RSpecFixtures.stdout.rewind

        original_stream = $stdout
        $stdout = RSpecFixtures.stdout
        block.call
        RSpecFixtures.stdout.string.dup

      ensure
        $stdout = original_stream

      end
    end

    module Stderr
      def self.capture(block)
        RSpecFixtures.stderr.truncate 0
        RSpecFixtures.stderr.rewind

        original_stream = $stderr
        $stderr = RSpecFixtures.stderr
        block.call
        RSpecFixtures.stderr.string.dup

      ensure
        $stderr = original_stream

      end
    end
  end
end