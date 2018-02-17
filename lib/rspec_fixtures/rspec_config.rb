# Add our custom matchers and configuration options to RSpec
if defined? RSpec
  RSpec.configure do |config|
    config.include RSpecFixtures::Matchers
    config.add_setting :fixtures_path, default: File.expand_path('spec/fixtures')
    config.add_setting :interactive_fixtures, default: !ENV['CI']
  end
end
