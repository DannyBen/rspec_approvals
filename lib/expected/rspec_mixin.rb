module Expected
  module RSpecMixin
    RSpec::Matchers.define :match_fixture do |expected|
      match do |actual| 
        TestCase.new(expected, actual).result
      end

      failure_message do |actual|
        TestCase.new(expected, actual).failure_message
      end
    end

    RSpec::Matchers.define :output_fixture do |expected|
      match do |actual| 
        TestCase.new(expected, actual, output: true).result
      end

      failure_message do |actual|
        TestCase.new(expected, actual, output: true).failure_message
      end

      def supports_block_expectations?
        true
      end
    end
  end
end

if defined? RSpec
  RSpec.configure do |config|
    config.include Expected::RSpecMixin
  end
end