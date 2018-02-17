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

        # TODO: Organize this mess (its the same as in OutputFixture)
        if distance
          actual_distance = String::Similarity.levenshtein_distance expected, actual
          success = actual_distance <= distance
        else
          success = actual == expected
        end

        if success or !interactive?
          success
        else
          approve_fixture
        end
      end
    end
    
  end
end