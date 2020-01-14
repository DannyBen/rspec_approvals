# Add our custom matchers and configuration options to RSpec
if defined? RSpec
  RSpec.configure do |config|
    config.include RSpecFixtures::Matchers
    config.add_setting :fixtures_path, default: File.expand_path('spec/fixtures')
    config.add_setting :interactive_fixtures, default: !ENV['CI']
    config.add_setting :auto_approve, default: ENV['AUTO_APPROVE']
    config.add_setting :strip_ansi_escape, default: false
    config.add_setting :before_approval, default: nil
  end
end
