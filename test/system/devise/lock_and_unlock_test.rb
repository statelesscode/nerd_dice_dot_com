require "application_system_test_case"

module Devise
  ######################################################################
  # System test for user lock and unlock via time and unlock token
  ######################################################################
  class LockAndUnlockTest < ApplicationSystemTestCase
    setup do
      @user = users(:player)
      @user.update(failed_attempts: 9)
      @bad_password = "Gygax"
    end

    test "warns user with one failed attempt left" do
      @user.update(failed_attempts: 8)
      login_with_credentials!(@user.email, @bad_password)

      # flash message
      assert_text "You have one more attempt before your account is locked."
      login_page_assertions!
    end

    test "locks after failed attempts reached" do
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

      # travel 1 hour into the future
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

    test "errors out if you try to resend unlock instructions to a bad email" do
      lock_account_and_demonstrate_behavior!

      click_on "Didn't receive unlock instructions?"

      resend_page_assertions_and_setup!

      fill_in "Email", with: "bogus.email@example.com"

      click_on "Resend unlock instructions"

      assert_text "Email not found"

      # still on resend unlock instructions page
      resend_page_assertions_and_setup!
    end

    private

      def lock_account_and_demonstrate_behavior!
        # assertions about previous state
        assert_nil @user.locked_at, "Expected locked_at to be nil before last failure"
        assert_nil @user.unlock_token, "Expected unlock_token to be nil before last failure"

        # start with one attempt before locking
        login_with_credentials!(@user.email, @bad_password)

        # flash message
        assert_text "Your account is locked."
        login_page_assertions!

        user_post_lock_assertions_and_get_token!

        # now user cannot log in even with valid credentials
        login_with_user!(@user)
        # flash message
        assert_text "Your account is locked."
        login_page_assertions!
      end

      def unlocked_login_behavior!
        login_with_user!(@user)

        # flash
        assert_text "Signed in successfully."

        # welcome page but logged in state
        welcome_page_logged_in_assertions!
      end

      def unlock_with_resend!
        resend_page_assertions_and_setup!

        click_on "Resend unlock instructions"

        # allow time for emails to catch up
        sleep 1
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

      def resend_page_assertions_and_setup!
        assert_text "Resend unlock instructions"
        assert_text "Log in"
        assert_text "Sign up"
        assert_text "Forgot your password?"
        assert_text "Didn't receive confirmation instructions?"
        fill_in "Email", with: @user.email
      end

      def user_post_lock_assertions_and_get_token!
        @user.reload
        assert_not_nil @user.locked_at, "Expected locked_at not to be nil after lock"
        assert_not_nil @user.unlock_token, "Expected unlock_token not to be nil after lock"

        @unlock_email = ActionMailer::Base.deliveries.last
        @unlock_token = get_token_from_email(@unlock_email, "unlock_token")
      end
  end
end
