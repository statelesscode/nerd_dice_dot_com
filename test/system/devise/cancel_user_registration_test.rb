require "application_system_test_case"

module Devise
  ######################################################################
  # System test for user account cancellation
  # * Includes testing of the confirmation which is broken by default
  #   with Devise and Turbo
  ######################################################################
  class CancelUserRegistrationTest < ApplicationSystemTestCase
    setup do
      @user = users(:player)
      login_with_user!(@user)
    end

    test "user can successfully cancel registration" do
      standard_cancel_user_preconditions!
      previous_count = User.count
      page.accept_confirm do
        click_on "Cancel my account"
      end
      # flash message
      assert_text "Bye! Your account has been successfully cancelled. We hope to see you again soon."
      welcome_page_not_logged_in_assertions!
      assert_equal previous_count - 1, User.count, "Expected User.count to decrease by 1"
    end

    test "user registration does not get cancelled if user dismisses confirmation" do
      standard_cancel_user_preconditions!
      previous_count = User.count
      page.dismiss_confirm do
        click_on "Cancel my account"
      end

      # still on registrations_edit page
      registrations_edit_assertions!

      assert_equal previous_count, User.count, "Expected User.count not to change"
    end

    ####################################################################
    #  Begin Helper Methods
    ####################################################################
    private

      def standard_cancel_user_preconditions!
        welcome_page_logged_in_assertions!
        click_on "Manage your account"
        registrations_edit_assertions!
      end
  end
end
