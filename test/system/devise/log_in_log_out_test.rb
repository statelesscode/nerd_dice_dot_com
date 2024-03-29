require "application_system_test_case"

module Devise
  ######################################################################
  # System test for user log in and log out process and invalid
  # credentials
  ######################################################################
  class LogInLogOutTest < ApplicationSystemTestCase
    setup do
      @user = users(:dm)
      @invalid_login_attempt_message = "Invalid Email or password."
    end

    # Uses the login_with_user! method in ApplicationSystemTestCase.
    # It was refactored out of this method after implementing the test
    test "user can log in" do
      login_with_user!(@user)
      # flash
      assert_text "Signed in successfully."

      # welcome page but logged in state
      welcome_page_logged_in_assertions!
    end

    test "provides error message if email is blank" do
      login_with_credentials!("", "something")
      # flash
      assert_text @invalid_login_attempt_message
      login_page_assertions!
    end

    test "provides error message if password is incorrect" do
      login_with_credentials!(@user.email, "something")
      # flash
      assert_text @invalid_login_attempt_message
      login_page_assertions!
    end

    test "user can logout and not access authenticated pages" do
      login_with_user!(@user)
      click_on "Log out"

      assert_text "Signed out successfully."
      # Attempt to visit authenticated_url as non-logged in user.
      # Will redirect back to the root_url with an alert flash
      visit authenticated_url

      assert_text "You need to sign in or sign up before continuing."
      login_page_assertions!
    end
  end
end
