require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
require 'rspec_fixtures'
Bundler.require :default, :development

include RSpecFixtures

RSpec.configure do |config|
  config.interactive_fixtures = ENV['DEVMODE']
  
  # Cleanup some fixutures, for good housekeeping
  config.after :suite do 
    ['no_such_fixture', 'create_me_please'].each do |name|
      file = "spec/fixtures/#{name}"
      File.delete file if File.exist? file
    end
  end
end

def supress_output
  original_stdout = $stdout
  $stdout = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
end
