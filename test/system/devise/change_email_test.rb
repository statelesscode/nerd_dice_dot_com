require "application_system_test_case"

module Devise
  ######################################################################
  # System test for user password and email change processes and error
  # handling.
  ######################################################################
  class ChangeEmailTest < ApplicationSystemTestCase
    setup do
      @user = users(:player)
      @current_password = FIXTURE_USER_PASSWORDS[@user.email]
      @new_email = "nerdy.dice@example.com"
      login_with_user!(@user)
      @email_validation_flash = "You updated your account successfully, but we need to verify your new " \
                                "email address. Please check your email and follow the confirmation link " \
                                "to confirm your new email address."
    end

    test "user can change email to a valid address" do
      email_change_happy_path_unconfirmed!

      # confirm the email
      visit user_confirmation_url(confirmation_token: @user.confirmation_token)
      # flash
      assert_text "Your email address has been successfully confirmed."
      @user.reload
      assert_equal @new_email, @user.email, "Expected email to equal email from form after confirmation"

      # ensure able to log out and log back in with new email
      welcome_page_logged_in_assertions!
      click_on "Log out"
      welcome_page_not_logged_in_assertions!
      login_with_credentials!(@new_email, @current_password)
      welcome_page_logged_in_assertions!
    end

    test "email change fails if invalid email format" do
      standard_email_edit_preconditions!
      fill_in "Email", with: "TAXATION IS THEFT"

      click_on "Update"

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

    test "email change fails if invalid confirmation token" do
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

    ####################################################################
    #  Begin Helper Methods
    ####################################################################
    private

      def standard_email_edit_preconditions!
        welcome_page_logged_in_assertions!
        click_on "Manage your account"
        registrations_edit_assertions!
        fill_in "Email", with: @new_email
        fill_in "Current password", with: @current_password
      end

      def email_change_happy_path_unconfirmed!
        @old_email = @user.email
        standard_email_edit_preconditions!

        click_on "Update"
        assert_text @email_validation_flash

        revisit_registrations_edit!

        @user.reload
        assert_equal @new_email, @user.unconfirmed_email, "Expected unconfirmed_email to equal email from form"
        assert_not_nil @user.confirmation_token
        assert_equal @old_email, @user.email, "Expected old email to remain if unconfirmed"
      end

      def revisit_registrations_edit!
        click_on "Manage your account"
        registrations_edit_assertions!
        assert_text "Currently waiting confirmation for: #{@new_email}"
      end
  end
end
