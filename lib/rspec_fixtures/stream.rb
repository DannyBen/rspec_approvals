require 'strings-ansi'

module RSpecFixtures
  # Capture stdout and stderr
  #
  # These methods are borrowed from rspec's built in matchers
  # https://github.com/rspec/rspec-expectations/blob/add9b271ecb1d65f7da5bc8a9dd8c64d81d92303/lib/rspec/matchers/built_in/output.rb
  module Stream
    module Stdout
      def self.capture(block)
        captured_stream = RSpecFixtures.stdout

        original_stream = $stdout
        $stdout = captured_stream

        block.call

        result = captured_stream.string.dup
        captured_stream.truncate 0
        captured_stream.rewind
        result

      ensure
        $stdout = original_stream
      end
    end

    module Stderr
      def self.capture(block)
        captured_stream = RSpecFixtures.stderr

        original_stream = $stderr
        $stderr = captured_stream

        block.call

        result = captured_stream.string.dup
        captured_stream.truncate 0
        captured_stream.rewind
        result
        
      ensure
        $stderr = original_stream
      end
    end
  end
end