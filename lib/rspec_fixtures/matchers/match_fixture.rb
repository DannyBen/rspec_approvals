require 'string-similarity'

module RSpecFixtures
  module Matchers
    # Adds the matcher to RSpec:
    # `expect(string).to match_fixture(file)`
    def match_fixture(expected)
      MatchFixture.new expected
    end
    
    class MatchFixture < Base
      # Called by RSpec
      def matches?(actual)
        @actual = actual
        super
      end
    end
    
  end
end