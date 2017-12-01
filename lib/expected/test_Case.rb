module Expected
  class TestCase
    include Colors

    attr_reader :fixture_name, :actual

    def initialize(fixture_name, actual)
      @fixture_name, @actual = fixture_name, actual
    end

    def result
      return true if actual == expected

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
        actual == expected
      end
    end

    def message
      "expected #{expected.inspect}\nto match #{actual.inspect}"
    end

    def expected
      @expected ||= expected!
    end

    def fixtures_dir
      'fixtures'
    end

    def fixture_file
      "#{fixtures_dir}/#{fixture_name}"
    end

    private

    def expected!
      Dir.mkdir fixtures_dir unless Dir.exist? fixtures_dir
      File.write fixture_file, nil unless File.exist? fixture_file
      File.read fixture_file
    end

  end
end
