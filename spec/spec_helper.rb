require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
require 'rspec_fixtures'
Bundler.require :default, :development

require_relative 'spec_mixin'

include RSpecFixtures

RSpec.configure do |config|
  config.include SpecMixin
  config.interactive_fixtures = ENV['DEVMODE']
  
  # Cleanup some fixutures, for good housekeeping
  config.after :suite do 
    ['command', 'no_such_fixture', 'create_me_please'].each do |name|
      file = "spec/fixtures/#{name}"
      File.delete file if File.exist? file
    end
  end

end
