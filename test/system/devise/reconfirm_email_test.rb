require "application_system_test_case"
require_relative "concerns/email_changeable"

module Devise
  ######################################################################
  # System test for user password and email change reconfirm processes
  # and error handling.
  ######################################################################
  class ReconfirmEmailTest < ApplicationSystemTestCase
    include EmailChangeable

    setup do
      common_email_setup
    end

    test "can reconfirm after invalid token" do
      # method defined in EmailChangeable
      email_change_happy_path_unconfirmed!

      # confirm the user with an invalid token
      visit user_confirmation_url(confirmation_token: "THISISNOTVALID")

      assert_text "Confirmation token is invalid"
      @user.reload

      assert_equal @old_email, @user.email, "Expected email to remain unchanged"

      reconfirm!(@new_email)

      # back to welcome with you are already logged in
      assert_text "You are already signed in."
      welcome_page_logged_in_assertions!

      valid_confirmation!(true)
    end

    test "user can reconfirm email from logged out state by entering old email" do
      logged_out_reconfirm!(@old_email)
    end

    test "user can reconfirm email from logged out state by entering new email" do
      logged_out_reconfirm!(@new_email)
    end

    ####################################################################
    #  Begin Helper Methods
    ####################################################################
    private

      # Shared logic for attempting to reconfirm from a logged out state
      # * Get the email change to the point where it sends the email
      # * Click on back to return to the root URL
      # * Click on the Log In button and then the "Didn't receive
      #   confirmation instructions?" link
      # * Call reconfirm! to setup the reconfirm page and hit the button
      # * Call the valid_confirmation! method from EmailChangeable to
      #   validate the behavior after confirming for a logged-out user
      #
      # @param email the email to fill in the form with
      def logged_out_reconfirm!(email)
        email_change_happy_path_unconfirmed!

        click_on "Back"
        click_on "Log out"
        welcome_page_not_logged_in_assertions!

        click_on "Log in"
        click_on "Didn't receive confirmation instructions?"

        reconfirm!(email)

        valid_confirmation!(false)
      end

      # Makes assertions about the state of the reconfirm email page,
      # fills out the reconfirm email form with the intended email, and
      # clicks the button to resend the instructions
      #
      # @param email the email to fill in the form with
      def reconfirm!(email)
        assert_text "Resend confirmation instructions"
        # reconfirm the email
        fill_in "Email", with: email
        await_jobs do
          click_on "Resend confirmation instructions"
        end
      end
  end
end
