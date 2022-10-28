require "test_helper"

# For configuration and customization of browser driven tests
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  DRIVER = if ENV["BROWSER_TEST_DRIVER"]
    ENV["BROWSER_TEST_DRIVER"].to_sym
  else
    :headless_chrome
  end

  driven_by :selenium, using: DRIVER, screen_size: [1400, 1400]

  # helper method for welcome page assertions
  def welcome_page_not_logged_in_assertions!
    assert_text "Nerd Dice"
    assert_text "Sign up"
    assert_text "Log in"
    assert_no_text "Visit the members' area"
    assert_no_text "Log out"
  end

  def welcome_page_logged_in_assertions!
    assert_text "Nerd Dice"
    assert_no_text "Sign up"
    assert_no_text "Log in"
    assert_text "Visit the members' area"
    assert_text "Log out"
  end
end
