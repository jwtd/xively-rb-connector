require 'rubygems'
require 'bundler/setup'
Bundler.setup

require 'rspec'
require 'webmock/rspec'
require 'time'

# figure out where we are being loaded from
if $LOADED_FEATURES.grep(/spec\/spec_helper\.rb/).any?
  begin
    raise "foo"
  rescue => e
    puts <<-MSG
  ===================================================
  It looks like spec_helper.rb has been loaded
  multiple times. Normalize the require to:

    require "spec/spec_helper"

  Things like File.join and File.expand_path will
  cause it to be loaded multiple times.

  Loaded this time from:

    #{e.backtrace.join("\n    ")}
  ===================================================
    MSG
  end
end

if !defined?(JRUBY_VERSION)
  if ENV["COVERAGE"] == "on"
    require 'simplecov'
    SimpleCov.start do
      add_filter "/spec/"
      add_filter "/lib/xively-rb.rb"
      add_filter "/vendor/"
      minimum_coverage 100
    end
  end
end

#Dir['./spec/support/**/*.rb'].map {|f| require f}

$:.push File.expand_path("../lib", __FILE__)
require 'xively-rb-connector'

#require File.dirname(__FILE__) + '/fixtures/models.rb'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
  config.run_all_when_everything_filtered = true

  # Webmock
  config.before(:each) do
    stub_request(:get, "https://api.xively.com/v2/feeds/000000001.json").
           with(:headers => {'User-Agent'=>'xively-rb/0.2.10', 'X-Apikey'=>'abcdefg'}).
           to_return(:status => 200,
                     :body => File.open(File.dirname(__FILE__) + '/support/fixtures/feed_100000000.json').read,
                     :headers => {})
  end

  # Use sinatra
  #config.before(:each) do
  #  stub_request(:any, /api.github.com/).to_rack(FakeGitHub)
  #end



end





