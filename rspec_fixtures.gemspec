lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'rspec_fixtures/version'

Gem::Specification.new do |s|
  s.name        = 'rspec_fixtures'
  s.version     = RSpecFixtures::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Interactive RSpec Fixtures"
  s.description = "Automatic interactive fixtures for rspec"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.homepage    = 'https://github.com/DannyBen/rspec_fixtures'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.0.0"

  s.add_runtime_dependency 'colsole', '~> 0.5'

  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'runfile', '~> 0.9'
  s.add_development_dependency 'runfile-tasks', '~> 0.4'
  s.add_development_dependency 'byebug', '~> 9.0'
  s.add_development_dependency 'simplecov', '~> 0.14'
  s.add_development_dependency 'yard', '~> 0.9'
  s.add_development_dependency 'string-similarity', '~> 2.0'
end
