require "application_system_test_case"

module Devise
  ######################################################################
  # System test for user ability to reset password and error conditions
  # Notes:
  # * All of these tests use utility methods defined at the bottom of
  #   the test class to refactor out repeated actions and assertions
  # * For the unhappy path tests, it fills the form out correctly and
  #   then changes the field(s) needed to create the error condition(s)
  ######################################################################
  class ResetPasswordTest < ApplicationSystemTestCase
    # starts from non-logged in state
    setup do
      @user = users(:dm)
      @new_password = "Freddie91Mercury"
    end

    test "user can reset password with valid email and token" do
      happy_path_about_to_hit_submit!
      click_on "Change my password"
      assert_text "Your password has been changed successfully. You are now signed in."
      welcome_page_logged_in_assertions!
    end

    test "user cannot reset password unless email matches a user" do
      standard_reset_password_preconditions!
      fill_in "Email", with: "bademail@example.com"
      assert_no_emails do
        await_jobs do
          click_on "Send me reset password instructions"
        end
      end
      assert_text "Email not found"
    end

    test "user cannot reset password with an invalid token" do
      standard_reset_password_preconditions!
      assert_emails 1 do
        good_email_flow!
      end
      # confirm the user with bad token
      visit edit_user_password_url(reset_password_token: "BAD-TOKEN")
      change_password_page_assertions!
      standard_password_reset_fill_in
      click_on "Change my password"
      assert_text "Reset password token is invalid"
    end

    test "reset password errors out if passwords don't match" do
      happy_path_about_to_hit_submit!
      # fill in a non-matching password
      fill_in "Confirm new password", with: "Brian99May"
      click_on "Change my password"
      assert_text "Password confirmation doesn't match Password"
    end

    test "reset password errors out if password too short" do
      happy_path_about_to_hit_submit!
      # fill in a too-short password
      fill_in "New password", with: "SHORT"
      fill_in "Confirm new password", with: "SHORT"
      click_on "Change my password"
      assert_text "Password is too short (minimum is 8 characters)"
    end

    ####################################################################
    #  Begin Helper Methods
    ####################################################################
    private

      # Gets the reset password workflow filled out with the "happy
      # path" scenario just before hitting submit on the password reset
      # page after successfully confirming the token. The state of the
      # form is overridden by the unhappy path tests by changing the
      # value(s) of the fields to set up the error scenarios.
      # * Call standard_reset_password_preconditions! to navigate the
      #   user to the forgot password page
      # * Call good_email_flow! to fill in the forgot password page
      #   correctly and assert that the reset password email was sent
      # * Call good_token_flow! to correctly visit the edit password
      #   page with a valid token
      # * Call change_password_page_assertions! to assert the proper
      #   state of the reset password page
      # * Call standard_password_reset_fill_in to get the reset
      #   password form filled out correctly but not submitted
      def happy_path_about_to_hit_submit!
        standard_reset_password_preconditions!
        assert_emails 1 do
          good_email_flow!
        end
        good_token_flow!
        change_password_page_assertions!
        standard_password_reset_fill_in
      end

      # Navigates the user to the forgot password page and makes
      # assertions about the correct states of the pages visited
      def standard_reset_password_preconditions!
        assert_nil @user.reset_password_token
        visit welcome_url
        welcome_page_not_logged_in_assertions!
        click_on "Log in"
        # click on forgot your password from Log in page
        click_on "Forgot your password?"
        # assertions about the Forgot password page
        assert_text "Log in"
        assert_text "Sign up"
        assert_text "Didn't receive confirmation instructions?"
        assert_text "Didn't receive unlock instructions?"
      end

      # Makes assertions about the correct state of the reset password
      # page
      def change_password_page_assertions!
        assert_text "Change your password"
        assert_text "Log in"
        assert_text "Sign up"
        assert_text "Didn't receive confirmation instructions?"
        assert_text "Didn't receive unlock instructions?"
      end

      # Fills in the forgot password page with the correct email and
      # asserts that the user has a reset_password_token populated with
      # the correct flash message displayed
      def good_email_flow!
        fill_in "Email", with: @user.email
        await_jobs do
          click_on "Send me reset password instructions"
        end
        assert_text "You will receive an email with instructions on how to reset " \
                    "your password in a few minutes."
        # reload user and assert password token no longer nil
        @user.reload
        assert_not_nil @user.reset_password_token
      end

      # Harvests the password reset token from the last delivered email
      # and uses it to visit the edit_user_password_url
      def good_token_flow!
        token = get_token_from_email(ActionMailer::Base.deliveries.last, "reset_password_token")
        # confirm the user
        visit edit_user_password_url(reset_password_token: token)
      end

      # Fills in the new password for the user with the intended new
      # password. Other tests can change the values to get the form to
      # a different state afterward.
      def standard_password_reset_fill_in
        fill_in "New password", with: @new_password
        fill_in "Confirm new password", with: @new_password
      end
  end
end
