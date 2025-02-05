lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_approvals/version'

Gem::Specification.new do |s|
  s.name        = 'rspec_approvals'
  s.version     = RSpecApprovals::VERSION
  s.summary     = 'Interactive RSpec Approvals'
  s.description = 'Automatic interactive approvals for rspec'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.homepage    = 'https://github.com/DannyBen/rspec_approvals'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.1'

  s.add_dependency 'colsole', '>= 0.8.1', '< 2'
  s.add_dependency 'diffy', '~> 3.4'
  s.add_dependency 'strings-ansi', '~> 0.2'
  s.add_dependency 'string-similarity', '~> 2.1'

  s.metadata['rubygems_mfa_required'] = 'true'
end
