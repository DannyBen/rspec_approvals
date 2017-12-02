require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
require 'rspec_fixtures'
Bundler.require :default, :development

include RSpecFixtures

RSpec.configure do |config|
  config.interactive_fixtures = ENV['DEVMODE']
end
