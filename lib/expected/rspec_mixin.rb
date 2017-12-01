module Expected
  module RSpecMixin
    RSpec::Matchers.define :match_approval do |expected|
      match do |actual| 
        TestCase.new(expected, actual).result
      end

      failure_message do |actual|
        TestCase.new(expected, actual).message
      end
    end
  end
end

RSpec.configure do |config|
  config.include Expected::RSpecMixin
end