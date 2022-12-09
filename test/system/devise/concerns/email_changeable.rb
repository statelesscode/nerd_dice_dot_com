module Devise
  ######################################################################
  # Helper methods shared by test classes that test changing and
  # reconfirming emails
  ######################################################################
  module EmailChangeable
    extend ActiveSupport::Concern

    private

      # common setup block shared by classes that test email change
      def common_email_setup
        @user = users(:player)
        @current_password = ActiveSupport::TestCase::FIXTURE_USER_PASSWORDS[@user.email]
        @new_email = "nerdy.dice@example.com"
        login_with_user!(@user)
        @email_validation_flash = "You updated your account successfully, but we need to verify your new " \
                                  "email address. Please check your email and follow the confirmation link " \
                                  "to confirm your new email address."
      end

      # Sets up all the email tests by getting the form to a state with
      # new email and current password filled out. Tests can override
      # this state by changing the fields from their default most common
      # state
      def standard_email_edit_preconditions!
        welcome_page_logged_in_assertions!
        click_on "Manage your account"
        registrations_edit_assertions!
        fill_in "Email", with: @new_email
        fill_in "Current password", with: @current_password
      end

      # Gets the email change to a state where the email has been changed
      # to the new email and the confirmation email has been sent and
      # makes assertions about the state of the user after confirmation
      # email is sent
      def email_change_happy_path_unconfirmed!
        @old_email = @user.email
        standard_email_edit_preconditions!

        update_and_assert_flash!

        revisit_registrations_edit!

        @user.reload
        assert_equal @new_email, @user.unconfirmed_email, "Expected unconfirmed_email to equal email from form"
        assert_not_nil @user.confirmation_token
        assert_equal @old_email, @user.email, "Expected old email to remain if unconfirmed"
      end

      # revisits registrations/edit to validate that the page notes that
      # it is currently waiting for the validation of the new email
      def revisit_registrations_edit!
        click_on "Manage your account"
        registrations_edit_assertions!
        assert_text "Currently waiting confirmation for: #{@new_email}"
      end

      # Visits the confirmation URL with the valid confirmation token
      # @param boolean indicating whether the user is current logged in
      #
      # After confirming it logs the user out if applicable and then
      # asserts that the user is able to log in with the new email
      def valid_confirmation!(logged_in)
        # confirm the email
        visit user_confirmation_url(confirmation_token: @user.confirmation_token)
        # flash
        assert_text "Your email address has been successfully confirmed."
        @user.reload
        assert_equal @new_email, @user.email, "Expected email to equal email from form after confirmation"

        confirmation_context_assertions!(logged_in)

        login_with_credentials!(@new_email, @current_password)
        welcome_page_logged_in_assertions!
      end

      # Makes different assertions depending on whether user was logged
      # in or not when the email was confirmed
      # @param boolean indicating whether the user is current logged in
      def confirmation_context_assertions!(logged_in)
        if logged_in
          # ensure able to log out and log back in with new email
          welcome_page_logged_in_assertions!
          click_on "Log out"
          welcome_page_not_logged_in_assertions!
        else
          login_page_assertions!
        end
      end

      # Clicks on the update button on the email edit page and asserts
      # the email validation flash is present
      def update_and_assert_flash!
        await_jobs do
          click_on "Update"
        end
        assert_text @email_validation_flash
      end
  end
end
