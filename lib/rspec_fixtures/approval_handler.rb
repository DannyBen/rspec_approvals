module RSpecFixtures
  class ApprovalHandler
    include Colors

    def run(expected, actual, fixture_file)
      puts "%{blue}--- Approval Needed ---%{reset}\n" % colors
      if expected.empty?
        puts actual
      else
        puts "--- New (Actual) ------%{reset}\n#{actual}" % colors
        puts "--- Old (Fixture) -----%{reset}\n#{expected}" % colors
      end
      print "%{blue}--- Approve? (y/N): --> %{reset}" % colors
      
      if user_approves?
        puts "%{green}Approved%{reset}" % colors
        File.write fixture_file, actual
        true
      else
        puts "%{red}Not Approved%{reset}" % colors
        false
      end
    end

    private

    def user_approves?
      $stdin.getch == 'y'
    end
  end
end