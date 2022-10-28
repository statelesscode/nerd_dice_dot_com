require "application_system_test_case"

module Devise
  ######################################################################
  # System test for user sign up process
  # Notes:
  # * All of these tests use utility methods defined at the bottom of
  #   the test class to refactor out repeated actions and assertions
  # * For the unhappy path tests, it fills the form out correctly and
  #   then changes the field(s) needed to create the error condition(s)
  ######################################################################
  class UserSignUpTest < ApplicationSystemTestCase
    setup do
      @new_user_email = "anewuser@example.com"
      @new_user_password = "testing1new3user2flow"
      @confirm_text = "A message with a confirmation link has been sent to your email address. " \
                      "Please follow the link to activate your account."
    end

    test "signing up and confirming new user" do
      user = happy_path_unconfirmed!
      # confirm the user
      visit user_confirmation_url(confirmation_token: user.confirmation_token)
      # flash
      assert_text "Your email address has been successfully confirmed."

      login_with_credentials!(@new_user_email, @new_user_password)
      # back to welcome page but logged in
      welcome_page_logged_in_assertions!
      assert_text "Signed in successfully."

      # assertions about the state of the user
      user.reload
      assert_not_nil user.confirmed_at
      assert_not_nil user.remember_created_at
      click_on "Visit the members' area"
      assert_text "Authenticated#index"
    end

    test "signup fails if invalid email" do
      standard_signup_start!

      # sign up flow
      click_on "Sign up" # from link in welcome
      sign_up_page_assertions!
      standard_signup_fill_in
      fill_in "Email", with: "TAXATION IS THEFT"
      click_on "Sign up" # button on signup

      error_message = page.find("#user_email").native.attribute("validationMessage")
      assert_equal("Please include an '@' in the email address. " \
                   "'TAXATION IS THEFT' is missing an '@'.", error_message)
    end

    test "signup fails if email address has been taken" do
      standard_signup_start!

      # sign up flow
      click_on "Sign up" # from link in welcome
      sign_up_page_assertions!
      standard_signup_fill_in
      fill_in "Email", with: users(:dm).email
      click_on "Sign up" # button on signup

      assert text "Email has already been taken"
    end

    test "signup fails if password too short" do
      standard_signup_start!

      # sign up flow
      click_on "Sign up" # from link in welcome
      sign_up_page_assertions!
      standard_signup_fill_in
      fill_in "Password", with: "SHORT"
      fill_in "Password confirmation", with: "SHORT"
      click_on "Sign up" # button on signup

      assert_text "Password is too short (minimum is 8 characters)"
    end

    test "signup fails if passwords don't match" do
      standard_signup_start!

      # sign up flow
      click_on "Sign up" # from link in welcome
      sign_up_page_assertions!
      standard_signup_fill_in
      fill_in "Password confirmation", with: "somethingelse"
      click_on "Sign up" # button on signup

      assert_text "Password confirmation doesn't match Password"
    end

    test "signup fails if invalid confirmation token" do
      happy_path_unconfirmed!

      # confirm the user with an invalid token
      visit user_confirmation_url(confirmation_token: "THISISNOTVALID")

      assert_text "Resend confirmation instructions"
      assert_text "Confirmation token is invalid"
    end

    ####################################################################
    #  Begin Helper Methods
    ####################################################################
    # rubocop:disable Minitest/TestMethodName
    def sign_up_page_assertions!
      assert_text "Sign up"
      assert_text "Password (8 characters minimum)"
      assert_text "Password confirmation"
    end

    def standard_signup_fill_in
      fill_in "Email", with: @new_user_email
      fill_in "Password", with: @new_user_password
      fill_in "Password confirmation", with: @new_user_password
    end

    def happy_path_unconfirmed!
      start_time = Time.now.utc
      # get to sign up page and assert correct content
      standard_signup_start!

      # sign up flow
      click_on "Sign up" # from link in welcome
      sign_up_page_assertions!
      standard_signup_fill_in
      click_on "Sign up" # button on signup

      # assert redirection of title and text of Welcome Page not logged in state
      welcome_page_not_logged_in_assertions!
      # flash
      assert_text @confirm_text

      # assertions about the unconfirmed useruser
      # implicitly returns the user
      unconfirmed_user_assertions!(start_time)
    end

    def unconfirmed_user_assertions!(start_time)
      # get last user (need to use created due to UUID primary key)
      unconfirmed_user = User.where("created_at >= ?", start_time).take
      assert_nil unconfirmed_user.confirmed_at
      assert_not_nil unconfirmed_user.confirmation_token

      # return user
      unconfirmed_user
    end

    def standard_signup_start!
      visit welcome_url
      welcome_page_not_logged_in_assertions!
    end
    # rubocop:enable Minitest/TestMethodName
  end
end
