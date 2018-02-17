module RSpecFixtures
  module Matchers

    # A base matcher for fixture approvals
    class Base
      attr_reader :fixture_name, :actual, :distance

      def initialize(fixture_name=nil)
        @fixture_name = fixture_name
      end

      # Called by RSpec. This will be overridden by child matchers.
      def matches?(actual)
        @actual = actual
        false
      end

      # Provides a chained matcher to do something like:
      # `expect(string).to match_fixture(file).diff(10)
      # The distance argument is the max allowed Levenshtein Distance.
      def diff(distance)
        @distance = distance
        self
      end

      # Returns the expected value, from a fixture file
      def expected
        @expected ||= expected!
      end

      # Called by RSpec when there is a failure
      def failure_message
        "expected #{actual}\nto match #{expected}"
      end

      # Lets RSpec know these matchers support diffing
      def diffable?
        true
      end

      # Returns true if RSpec is configured to allow interactivity.
      # By default, interactivity is enabled unless the environment 
      # variable `CI` is set.
      def interactive?
        RSpec.configuration.interactive_fixtures
      end

      # Returns the path to the fixtures directory.
      # Default: `spec/fixtures`
      def fixtures_dir
        RSpec.configuration.fixtures_path
      end

      # Returns the path to the fixture file
      def fixture_file
        "#{fixtures_dir}/#{fixture_name}"
      end
      
      protected

      # Asks for user approval. Used by child classes.
      def approve_fixture
        approval_handler = ApprovalHandler.new
        approval_handler.run expected, actual, fixture_file
      end

      # Return the actual fixture file content.
      def expected!
        File.exist?(fixture_file) ? File.read(fixture_file) : ''
      end
    end

  end
end
