if defined? RSpec
  RSpec.configure do |config|
    config.include RSpecFixtures::Matchers
    config.add_setting :fixtures_path, default: 'spec/fixtures'
    config.add_setting :interactive_fixtures, default: !ENV['CI']
  end
end
