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
    # uses a brand new user that is not one of the User fixtures
    setup do
      @new_user_email = "anewuser@example.com"
      @new_user_password = "testing1new3user2flow"
      @confirm_text = "A message with a confirmation link has been sent to your email address. " \
                      "Please follow the link to activate your account."
    end

    # User sign up "happy path"
    # * Call happy_path_unconfirmed! to get to the point where the
    #   User is created but unconfirmed
    # * Confirm the user by visiting the user_confirmation_url with the
    #   correct token
    # * Log in with the user's credential to ensure the user can log in
    #   after confirming
    # * Make assertions about the state of the confirmed User
    # * Test that the user can visit the Authenticated URL
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
      signup_page_flow!

      fill_in "Email", with: "TAXATION IS THEFT"
      click_on "Sign up" # button on signup

      # causes a native HTML5 form validation error
      error_message = get_input_validation_message("#user_email")

      assert_equal("Please include an '@' in the email address. " \
                   "'TAXATION IS THEFT' is missing an '@'.", error_message)
    end

    test "signup fails if email address has been taken" do
      standard_signup_start!
      signup_page_flow!

      fill_in "Email", with: users(:dm).email
      click_on "Sign up" # button on signup

      assert text "Email has already been taken"
    end

    test "signup fails if password too short" do
      standard_signup_start!
      signup_page_flow!

      fill_in "Password", with: "SHORT"
      fill_in "Password confirmation", with: "SHORT"
      click_on "Sign up" # button on signup

      assert_text "Password is too short (minimum is 8 characters)"
    end

    test "signup fails if passwords don't match" do
      standard_signup_start!
      signup_page_flow!

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
    private

      def sign_up_page_assertions!
        assert_text "Sign up"
        assert_text "Password (8 characters minimum)"
        assert_text "Password confirmation"
      end

      # Fills in the form with happy path data.
      # Error scenarios override one or more fields by filling in new
      # values after calling this method.
      def standard_signup_fill_in
        fill_in "Email", with: @new_user_email
        fill_in "Password", with: @new_user_password
        fill_in "Password confirmation", with: @new_user_password
      end

      # Follows through the happy path from the beginning until after
      # hitting Sign up when the user is about to be confirmed
      # * Take the start time to get the first user created on or after
      #   the start time
      # * Fill out the sign up form correctly and click on the Sign up
      #   button
      # * Assert that the confirmation email gets sent to the user
      # * Calls unconfirmed_user_assertions! to make assertions about
      #   the state of the unconfirmed user
      def happy_path_unconfirmed!
        start_time = Time.now.utc
        # this process should send the email confirmation email
        assert_emails 1 do
          # get to sign up page and assert correct content
          standard_signup_start!
          signup_page_flow!
          click_on "Sign up" # button on signup

          # assert redirection of title and text of Welcome Page not logged in state
          welcome_page_not_logged_in_assertions!
          # flash
          assert_text @confirm_text
        end
        # assertions about the unconfirmed user
        # implicitly returns the user
        unconfirmed_user_assertions!(start_time)
      end

      # Make assertions about the state of the newly created and
      # unconfirmed user
      def unconfirmed_user_assertions!(start_time)
        # get last user (need to use created due to UUID primary key)
        unconfirmed_user = User.find_by("created_at >= ?", start_time)

        assert_nil unconfirmed_user.confirmed_at
        assert_not_nil unconfirmed_user.confirmation_token

        # return user
        unconfirmed_user
      end

      # Get the user to the welcome URL and make assertions about the
      # welcome page
      def standard_signup_start!
        visit welcome_url
        welcome_page_not_logged_in_assertions!
      end

      # Get the user to the signup page, make assertions about its
      # state, and then call standard_signup_fill_in to get the form
      # prepared and filled out correctly
      def signup_page_flow!
        await_jobs do
          click_on "Sign up" # from link in welcome
        end
        sign_up_page_assertions!
        standard_signup_fill_in
      end
  end
end
