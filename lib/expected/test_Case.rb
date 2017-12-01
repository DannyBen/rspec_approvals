module Expected
  class TestCase
    attr_reader :fixture_name, :actual

    def initialize(fixture_name, actual)
      @fixture_name, @actual = fixture_name, actual
    end

    def result
      return true if actual == expected

      puts "=== Approval Needed ===\n"
      if expected.empty?
        puts actual
      else
        puts "--- Actual ------------\n#{actual}"
        puts "--- Expected ----------\n#{expected}"
      end
      puts "======================="
      
      print "Approve? (y/N): "
      
      if $stdin.getch == "y"
        puts "Approved"
        File.write fixture_file, actual
        true
      else
        puts "Not Approved"
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
