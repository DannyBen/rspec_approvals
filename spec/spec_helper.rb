require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
require 'rspec_approvals'
Bundler.require :default, :development

require_relative 'spec_mixin'

include RSpecApprovals

RSpec.configure do |config|
  config.include SpecMixin
  config.interactive_approvals = ENV['DEVMODE']

  # Cleanup some fixutures, for good housekeeping
  config.after :suite do
    %w[command no_such_approval create_me_please].each do |name|
      file = "spec/approvals/#{name}"
      FileUtils.rm_f file
    end
  end
end
