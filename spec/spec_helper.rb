$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bundler/setup'
Bundler.require :test

SimpleCov.formatter =
  if ENV['CI']
    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  else
    SimpleCov::Formatter::HTMLFormatter
  end

SimpleCov.start { add_filter 'spec/' } unless ENV['SKIPCOV']

require 'baby_squeel'
require 'support/schema'
require 'support/models'
require 'support/matchers'

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.example_status_persistence_file_path = 'tmp/spec-results.log'
  config.filter_run_excluding compat: !ENV['COMPAT']

  config.before :suite do
    puts "\nRunning with ActiveRecord #{ActiveRecord::VERSION::STRING}"

    if ENV['COMPAT']
      puts "Running in Squeel Compatibility mode"
      BabySqueel.enable_compatibility!
    end
  end
end
