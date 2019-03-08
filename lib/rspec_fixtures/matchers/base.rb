module RSpecFixtures
  module Matchers

    # A base matcher for fixture approvals
    class Base
      attr_reader :fixture_name, :actual, :distance, :actual_distance

      def initialize(fixture_name=nil)
        @fixture_name = fixture_name
      end

      # Called by RSpec. This will be overridden by child matchers.
      def matches?(actual)
        @actual ||= actual
        return false if @actual.empty?

        success = strings_match?

        if success or !interactive?
          success
        else
          approve_fixture
        end
      end

      # Provides a chained matcher to do something like:
      # `expect(string).to match_fixture(file).diff(10)
      # The distance argument is the max allowed Levenshtein Distance.
      def diff(distance)
        @distance = distance
        self
      end

      def except(regex)
        before ->(str) do
          begin
            str[regex, 1] = '...'
          rescue IndexError
          end
          str
        end
      end

      # Provides a chained matcher to adjust the actual string before
      # checking for matches:
      # `expect(a).to match_fixture(f).before ->(actual) { actual.gsub /one/, 'two' }`
      def before(proc)
        @before ||= []
        @before << proc
        self
      end

      # Returns the expected value, from a fixture file
      def expected
        @expected ||= expected!
      end

      # Called by RSpec when there is a failure
      def failure_message
        return "actual string is empty" if actual.empty?

        result = "expected: #{actual}\nto match: #{expected}"
        
        if distance
          result = "#{result}\n(actual distance is #{actual_distance} instead of the expected #{distance})"
        end

        result
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

      # Returns the actual fixture file content.
      def expected!
        File.exist?(fixture_file) ? File.read(fixture_file) : ''
      end

      # Do the actual test. 
      # - If .before() was used, we foreard the actual output to the
      #   proc for processing first.
      # - If .diff() was used, then distance will be set and then 
      #   we "levenshtein it". 
      # - Otherwise, compare with ==
      def strings_match?
        if @before
          @before.each do |proc|
            @actual = proc.call actual 
          end
        end

        if distance
          @actual_distance = String::Similarity.levenshtein_distance expected, actual
          @actual_distance <= distance
        else
          actual == expected
        end
      end

    end

  end
end
