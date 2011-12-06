require 'rubygems'
require 'bundler/setup'
require 'automata'

RSpec.configure do |config|
  config.before(:each) do
    Log.debug "Example Group: #{example.example_group.description}"
    Log.debug "Example: #{example.description}"
    Log.debug "Example Location: #{example.location}"
  end
  config.after(:each) do
      browser.close_current_browser_session unless browser.nil?
  end
  config.include(Browser::Driver)
  config.include(Browser::DomainDiscovery)
  config.include(TestUtilities)
  config.include(XmlHelper)
end
