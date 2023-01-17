require "application_system_test_case"

module Devise
  ######################################################################
  # System test for user lock and unlock via time and unlock token
  ######################################################################
  class LockAndUnlockTest < ApplicationSystemTestCase
    # start from logged out context with failed_attempts set to 9
    setup do
      @user = users(:player)
      @user.update(failed_attempts: 9)
      @bad_password = "Gygax"
      @paranoid_error = "Invalid Email or password"
      @paranoid_unlock_instructions = "If your account exists, you will " \
                                      "receive an email with instructions for how to unlock it in a few minutes."
    end

    test "provides no feedback if one attempt left" do
      # Change failed attempts back to 8 to test the message for the
      # ninth attempt
      @user.update(failed_attempts: 8)
      login_with_credentials!(@user.email, @bad_password)

      # flash message
      assert_text @paranoid_error
      # still on login page
      login_page_assertions!
    end

    test "locks after failed attempts reached" do
      # This is the standard scenario that gets us to a locked state on
      # the tenth failed attempt
      lock_account_and_demonstrate_behavior!
    end

    test "user can unlock account via emailed token" do
      lock_account_and_demonstrate_behavior!

      # visit the user_unlock_url with valid token
      visit user_unlock_path(unlock_token: @unlock_token)

      # flash message after successful unlock
      assert_text "Your account has been unlocked successfully. Please sign in to continue."

      # log back in to demonstrate unlock
      unlocked_login_behavior!
    end

    test "user account unlocks after specified time elapses" do
      lock_account_and_demonstrate_behavior!

      # travel 1 hour and 1 minute into the future
      travel(1.hour + 1.minute)

      # now user can log in again after unlock period is expired
      unlocked_login_behavior!
    end

    test "user cannot unlock with invalid token and can resend" do
      lock_account_and_demonstrate_behavior!

      # visit the user_unlock_url with valid token
      visit user_unlock_path(unlock_token: "BADTOKEN")

      # takes you to resend unlock instructions page with error message
      assert_text "Unlock token is invalid"

      unlock_with_resend!
    end

    test "user can resend unlock instructions and unlock" do
      lock_account_and_demonstrate_behavior!

      click_on "Didn't receive unlock instructions?"

      unlock_with_resend!
    end

    test "provides no feedback if you try to resend unlock instructions to a bad email" do
      lock_account_and_demonstrate_behavior!

      click_on "Didn't receive unlock instructions?"

      resend_page_assertions_and_setup!

      assert_no_emails do
        fill_in "Email", with: "bogus.email@example.com"

        click_on "Resend unlock instructions"
      end

      # redirects to login page with no feedback
      assert_text @paranoid_unlock_instructions

      login_page_assertions!
    end

    private

      # This is the common functionality for all locking tests.
      #
      # * Makes assertions about the beginning state of the user
      # * Logs in the tenth time to lock the user
      # * Makes assertions that the flash message alerts the user to the
      #   lock and that the user is still on the login page
      # * Calls user_post_lock_assertions_and_get_token! to test locked
      #   User state
      # * Tries to login with the user's correct credentials and tests
      #   that it is unsuccessful because the user is now locked
      def lock_account_and_demonstrate_behavior!
        # assertions about previous state
        assert_nil @user.locked_at, "Expected locked_at to be nil before last failure"
        assert_nil @user.unlock_token, "Expected unlock_token to be nil before last failure"

        # start with one attempt before locking
        login_with_credentials!(@user.email, @bad_password)

        # flash message
        assert_text @paranoid_error
        login_page_assertions!

        user_post_lock_assertions_and_get_token!

        # now user cannot log in even with valid credentials
        login_with_user!(@user)
        # flash message
        assert_text @paranoid_error
        login_page_assertions!
      end

      # Called to test that the unlocked user can now log in again
      def unlocked_login_behavior!
        login_with_user!(@user)

        # flash
        assert_text "Signed in successfully."

        # welcome page but logged in state
        welcome_page_logged_in_assertions!
      end

      # Tests the scenario where the User is on the unlocks/new page
      # and attempts to fill in his email and hit Resend unlock
      # instructions
      # * Makes assertions about the unlocks/new page and fills in with
      #   the user's current email
      # * Clicks on Resend unlock instructions
      # * Gets the new unlock token from the latest email
      # * Asserts that the new unlock token is different from the old
      #   one (digest gets re-hashed)
      # * Visits the unlock path with the correct new token
      # * Asserts that the user can log in and operate normally
      def unlock_with_resend!
        resend_page_assertions_and_setup!

        await_jobs do
          click_on "Resend unlock instructions"
        end

        new_unlock_email = ActionMailer::Base.deliveries.last
        new_unlock_token = get_token_from_email(new_unlock_email, "unlock_token")

        assert_not_equal @unlock_token, new_unlock_token, "Expected unlock token to change"

        # visit the user_unlock_url with valid token
        visit user_unlock_path(unlock_token: new_unlock_token)

        # flash message after successful unlock
        assert_text "Your account has been unlocked successfully. Please sign in to continue."

        # log back in to demonstrate unlock
        unlocked_login_behavior!
      end

      # Assertions about the unlocks/new page and fills in Email with
      # user's email by default. (Changed by the unhappy path after.)
      def resend_page_assertions_and_setup!
        assert_text "Resend unlock instructions"
        assert_text "Log in"
        assert_text "Sign up"
        assert_text "Forgot your password?"
        assert_text "Didn't receive confirmation instructions?"
        fill_in "Email", with: @user.email
      end

      # Makes assertions about the state of the user after the lock has
      # occurred.
      #
      # SIDE EFFECTS:
      # * Reloads the @user instance variable
      # * Sets the @unlock_email and @unlock_token instance variables
      def user_post_lock_assertions_and_get_token!
        @user.reload
        assert_not_nil @user.locked_at, "Expected locked_at not to be nil after lock"
        assert_not_nil @user.unlock_token, "Expected unlock_token not to be nil after lock"

        @unlock_email = ActionMailer::Base.deliveries.last
        @unlock_token = get_token_from_email(@unlock_email, "unlock_token")
      end
  end
end
