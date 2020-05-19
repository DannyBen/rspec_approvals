lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'rspec_approvals/version'

Gem::Specification.new do |s|
  s.name        = 'rspec_approvals'
  s.version     = RSpecApprovals::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Interactive RSpec Approvals"
  s.description = "Automatic interactive approvals for rspec"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.homepage    = 'https://github.com/DannyBen/rspec_approvals'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.3.0"

  s.add_runtime_dependency 'colsole', '~> 0.5'
  s.add_runtime_dependency 'string-similarity', '~> 2.0'
  s.add_runtime_dependency 'diffy', '~> 3.3'
  s.add_runtime_dependency 'tty-prompt', '~> 0.19'
  s.add_runtime_dependency 'strings-ansi', '~> 0.1'
end
