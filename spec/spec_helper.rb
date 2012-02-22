require 'rubygems'
require 'bundler/setup'
require 'automata'
require File.dirname(__FILE__) + "/../lib/mine_sweeper"
RSpec.configure do |config|
   config.before(:each) do
    Log.debug "Example Group: #{example.example_group.description}"
    Log.debug "Example: #{example.description}"
  end
  config.after(:each) do
    browser.close_current_browser_session unless (browser.nil? || browser.session_id.nil?)
    driver.quit unless driver.nil?
  end
  config.include(Browser::DomainDiscovery)
  config.include(Browser::Driver)
  config.include(TestUtilities)
end
