$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
Bundler.setup
require "selenium_fury"
require "rspec"
include SeleniumFury::SeleniumWebDriver::CreateSeleniumWebDriver
include SeleniumFury::SeleniumClient::CreateSeleniumClientDriver
require File.dirname(__FILE__) + "/../lib/logging"
require File.dirname(__FILE__) + "/../lib/coordinates"
require File.dirname(__FILE__) + "/../lib/mine_sweeper"
require File.dirname(__FILE__) + "/../lib/mark_blocks"
RSpec.configure do |config|
  config.after(:each) do
    browser.close_current_browser_session unless(browser.nil? || browser.session_id.nil?)
    driver.quit unless driver.nil?
  end
end
