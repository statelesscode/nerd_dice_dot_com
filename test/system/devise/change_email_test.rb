require "application_system_test_case"
require_relative "concerns/email_changeable"

module Devise
  ######################################################################
  # System test for user password and email change processes and error
  # handling.
  #
  # Uses the EmailChangeable concern for shared helper_methods that are
  # called in the bodies of the tests
  ######################################################################
  class ChangeEmailTest < ApplicationSystemTestCase
    include EmailChangeable

    # setup method is in EmailChangeable. Start logged in.
    setup do
      common_email_setup
    end

    test "user can change email to a valid address" do
      email_change_happy_path_unconfirmed!

      # tests that it follows the expectations for a logged in user
      valid_confirmation!(true)
    end

    test "email change fails if invalid email format" do
      standard_email_edit_preconditions!
      fill_in "Email", with: "TAXATION IS THEFT"

      click_on "Update"

      # defined in ApplicationSystemTestCase
      error_message = get_input_validation_message("#user_email")
      assert_equal("Please include an '@' in the email address. " \
                   "'TAXATION IS THEFT' is missing an '@'.", error_message)
    end

    test "email change fails if email address has been taken" do
      standard_email_edit_preconditions!
      fill_in "Email", with: users(:dm).email
      click_on "Update"

      assert text "Email has already been taken"
    end

    test "email change fails if invalid confirmation token and can reconfirm" do
      email_change_happy_path_unconfirmed!

      # confirm the user with an invalid token
      visit user_confirmation_url(confirmation_token: "THISISNOTVALID")

      assert_text "Resend confirmation instructions"
      assert_text "Confirmation token is invalid"
      @user.reload

      assert_equal @old_email, @user.email, "Expected email to remain unchanged"
    end

    test "email change fails if old password is incorrect" do
      standard_email_edit_preconditions!
      fill_in "Current password", with: "FinalFantasyVI"
      click_on "Update"

      assert_text "Current password is invalid"
    end

    test "email change fails if old password is blank" do
      standard_email_edit_preconditions!
      fill_in "Current password", with: ""
      click_on "Update"

      assert_text "Current password can't be blank"
    end
  end
end
