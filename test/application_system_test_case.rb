require "test_helper"

# For configuration and customization of browser driven tests
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  DRIVER = if ENV["BROWSER_TEST_DRIVER"]
    ENV["BROWSER_TEST_DRIVER"].to_sym
  else
    :headless_chrome
  end

  driven_by :selenium, using: DRIVER, screen_size: [1400, 1400]
end
