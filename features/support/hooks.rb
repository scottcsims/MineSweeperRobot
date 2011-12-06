After do
  Log.debug "Closing Browser Session"
  browser.close_current_browser_session if defined?(browser) && !browser.nil?
end

