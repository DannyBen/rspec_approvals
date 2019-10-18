require 'strings-ansi'

module RSpecFixtures
  # Capture stdout and stderr
  #
  # These methods are borrowed from rspec's built in matchers
  # https://github.com/rspec/rspec-expectations/blob/add9b271ecb1d65f7da5bc8a9dd8c64d81d92303/lib/rspec/matchers/built_in/output.rb
  module CaptureStdout
    def self.capture(block)
      captured_stream = StringIO.new

      original_stream = $stdout
      $stdout = captured_stream

      block.call

      captured_stream.string

    ensure
      $stdout = original_stream
    end
  end

  module CaptureStderr
    def self.capture(block)
      captured_stream = StringIO.new

      original_stream = $stderr
      $stderr = captured_stream

      block.call

      captured_stream.string
      
    ensure
      $stderr = original_stream
    end
  end
end