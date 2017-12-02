module RSpecFixtures
  module Matchers
    def match_fixture(expected)
      MatchFixture.new expected
    end
    
    class MatchFixture
      include Colors

      attr_reader :fixture_name, :actual

      def initialize(fixture_name=nil)
        @fixture_name = fixture_name
      end

      def matches?(actual)
        @actual = actual
        if actual == expected or !interactive?
          actual == expected
        else
          approve_fixture
        end
      end

      def expected
        @expected ||= expected!
      end

      def failure_message
        "expected #{actual}\nto match #{expected}"
      end

      def diffable?
        true
      end

      private

      def interactive?
        RSpec.configuration.interactive_fixtures
      end

      def fixtures_dir
        RSpec.configuration.fixtures_path
      end

      def fixture_file
        "#{fixtures_dir}/#{fixture_name}"
      end

      def approve_fixture
        puts "%{blue}--- Approval Needed ---%{reset}\n" % colors
        if expected.empty?
          puts actual
        else
          puts "--- New (Actual) ------%{reset}\n#{actual}" % colors
          puts "--- Old (Fixture) -----%{reset}\n#{expected}" % colors
        end
        print "%{blue}--- Approve? (y/N): --> %{reset}" % colors
        
        if $stdin.getch == "y"
          puts "%{green}Approved%{reset}" % colors
          File.write fixture_file, actual
          true
        else
          puts "%{red}Not Approved%{reset}" % colors
          false
        end
      end

      def expected!
        Dir.mkdir fixtures_dir unless Dir.exist? fixtures_dir
        File.write fixture_file, nil unless File.exist? fixture_file
        File.read fixture_file
      end
    end
  end
end