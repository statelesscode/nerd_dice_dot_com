require "test_helper"

# For configuration and customization of browser driven tests
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # needed in order to test email delivery in System Tests
  include ActionMailer::TestHelper

  # The default driver for system tests is :headless_chrome
  #
  # This allows for the GitHub actions to build and run correctly and
  # is faster than running with a visual browser. Occasionally for
  # debugging or browser compatibility purposes you might want to run
  # tests with a different browser. In order to do so, you can specify
  # the BROWSER_TEST_DRIVER environment variable.
  #
  # Example to use chrome instead of headless_chrome for the current test
  # run:
  # $> BROWSER_TEST_DRIVER=chrome rails test:system
  DRIVER = if ENV["BROWSER_TEST_DRIVER"]
    ENV["BROWSER_TEST_DRIVER"].to_sym
  else
    :headless_chrome
  end

  driven_by :selenium, using: DRIVER, screen_size: [1400, 1400]

  # assertions about the state of the welcome#index page when not logged
  # in
  def welcome_page_not_logged_in_assertions!
    assert_text "Nerd Dice"
    assert_text "Sign up"
    assert_text "Log in"
    assert_no_text "Visit the members' area"
    assert_no_text "Manage your account"
    assert_no_text "Log out"
  end

  # assertions about the state of the welcome#index page when logged in
  def welcome_page_logged_in_assertions!
    assert_text "Nerd Dice"
    assert_no_text "Sign up"
    assert_no_text "Log in"
    assert_text "Visit the members' area"
    assert_text "Manage your account"
    assert_text "Log out"
  end

  # Logs in an existing fixture user with the user's fixture stored
  # password. Used as a shortcut to finding and using or hardcoding
  # user passwords in all system tests
  #
  # @param user The User model object to attempt to log in with
  #
  # Finds the password for the user in the
  # ActiveSupport::TestCase::FIXTURE_USER_PASSWORDS hash
  #
  # NOTE: This will not work on users unless their email and password
  # are added to the constant above which is defined in test_helper.rb
  def login_with_user!(user)
    login_with_credentials!(user.email, FIXTURE_USER_PASSWORDS[user.email])
  end

  # Logs in a user with specific credentials by navigating to the log in
  # page, filling out the form with the Email and Password specified,
  # and then clicking on Log In
  #
  # @param email The email address to enter into the Email input field
  # @param password The password to enter into the Password input field
  def login_with_credentials!(email, password)
    visit new_user_session_url
    login_page_assertions!
    fill_in "Email", with: email
    fill_in "Password", with: password
    check "Remember me"
    click_on "Log in"
  end

  # assertions about the state of the Devise log in page
  # (new_user_session_url or /sessions/new)
  def login_page_assertions!
    assert_text "Log in"
    assert_text "Remember me"
    assert_text "Sign up"
    assert_text "Forgot your password?"
    assert_text "Didn't receive confirmation instructions?"
    assert_text "Didn't receive unlock instructions?"
  end

  # assertions about the state of the Devise registrations/edit page
  def registrations_edit_assertions!
    assert_text "Edit User"
    assert_text "Email"
    # query selector for the default value of the email input
    assert_selector "input#user_email[value='#{@user.email}']"
    assert_text "Password (leave blank if you don't want to change it)"
    assert_text "8 characters minimum"
    assert_text "Password confirmation"
    assert_text "Current password"
    assert_text "(we need your current password to confirm your changes)"
    assert_text "Cancel my account"
    assert_text "Unhappy?"
  end

  # Get a validation message from a page element
  # @param current_selector the unique selector of the element to find the message for
  #
  # Will return the validationMessage of the element (empty string if none)
  def get_input_validation_message(current_selector)
    page.find(current_selector).native.attribute("validationMessage")
  end
end
