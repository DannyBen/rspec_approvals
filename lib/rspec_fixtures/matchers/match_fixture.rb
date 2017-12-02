module RSpecFixtures
  module Matchers
    def match_fixture(expected)
      MatchFixture.new expected
    end
    
    class MatchFixture < Base
      def matches?(actual)
        @actual = actual
        if actual == expected or !interactive?
          actual == expected
        else
          approve_fixture
        end
      end
    end
    
  end
end