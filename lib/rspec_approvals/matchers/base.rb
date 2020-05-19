module RSpecApprovals
  module Matchers

    # A base matcher for approvals
    class Base
      attr_reader :approval_name, :actual, :distance, :actual_distance

      def initialize(approval_name=nil)
        @before = nil
        @approval_name = approval_name
      end

      # Called by RSpec. This will be overridden by child matchers.
      def matches?(actual)
        @actual ||= actual
        return false if @actual.empty?

        @actual = sanitize @actual
        success = strings_match?

        if success or !interactive?
          success
        else
          approve_approval
        end
      end

      # Enables the ability to do something like:
      # `expect(string).to match_approval(file).diff(10)
      # The distance argument is the max allowed Levenshtein Distance.
      def diff(distance)
        @distance = distance
        self
      end

      # Enables the ability to do something like:
      # `expect(string).to match_approval(file).except(/\d+/)
      def except(regex, replace = '...')
        before ->(str) do
          str.gsub regex, replace
        end
      end

      # Enables the ability to adjust the actual string before checking
      # for matches:
      # `expect(a).to match_approval(f).before ->(actual) { actual.gsub /one/, 'two' }`
      def before(proc)
        @before ||= []
        @before << proc
        self
      end

      # Returns the expected value, from an approval file
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

      # Returns true if RSpec is configured to sanitize (remove ANSI escape
      # codes) from the actual strings before proceeeding to comparing them.
      def sanitize?
        RSpec.configuration.strip_ansi_escape
      end

      # Returns true if RSpec is configured to allow interactivity.
      # By default, interactivity is enabled unless the environment 
      # variable `CI` is set.
      def interactive?
        RSpec.configuration.interactive_approvals
      end

      # Returns the path to the approvals directory.
      # Default: `spec/approvals`
      def approvals_dir
        RSpec.configuration.approvals_path
      end

      # Returns the path to the approval file
      def approval_file
        "#{approvals_dir}/#{approval_name}"
      end
      
    protected

      # Asks for user approval. Used by child classes.
      def approve_approval
        approval_handler = ApprovalHandler.new
        approval_handler.run expected, actual, approval_file
      end

      # Returns the actual approval file content.
      def expected!
        File.exist?(approval_file) ? File.read(approval_file) : ''
      end

      # Do the actual test. 
      # - If .before() was used, we foreward the actual output to the
      #   proc for processing first.
      # - If before_approval proc was configured, forward the acual output
      #   to the proc for processing.
      # - If .diff() was used, then distance will be set and then 
      #   we "levenshtein it". 
      # - Otherwise, compare with ==
      def strings_match?
        if @before
          @before.each do |proc|
            @actual = proc.call actual 
          end
        end
        
        if RSpec.configuration.before_approval.is_a? Proc
          @actual = RSpec.configuration.before_approval.call actual
        end

        if distance
          @actual_distance = String::Similarity.levenshtein_distance expected, actual
          @actual_distance <= distance
        else
          actual == expected
        end
      end

      # Returns the input string stripped of ANSI escape codes if the 
      # strip_ansi_escape configuration setting was set to true
      def sanitize(string)
        sanitize? ? Strings::ANSI.sanitize(string) : string
      end
    end

  end
end
