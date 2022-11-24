require "application_system_test_case"

module Devise
  ######################################################################
  # System test for user password change processes and error
  # handling.
  ######################################################################
  class ChangePasswordTest < ApplicationSystemTestCase
    # Start from logged in context.
    setup do
      @user = users(:player)
      @current_password = FIXTURE_USER_PASSWORDS[@user.email]
      @new_password = "Gr@z'ztAby$s"
      login_with_user!(@user)
    end

    test "user can change password to another valid password" do
      standard_password_edit_preconditions!
      click_on "Update"
      assert_text "Your account has been updated successfully."
      welcome_page_logged_in_assertions!
    end

    test "provides error message if new password too short" do
      standard_password_edit_preconditions!
      fill_in "Password", with: "DWARF"
      fill_in "Password confirmation", with: "DWARF"
      click_on "Update"

      assert_text "Password is too short (minimum is 8 characters)"
    end

    test "provides error message if new password confirmation mismatch" do
      standard_password_edit_preconditions!
      fill_in "Password confirmation", with: "Asmodeus1337"
      click_on "Update"

      assert_text "Password confirmation doesn't match Password"
    end

    test "provides error message if old password is incorrect" do
      standard_password_edit_preconditions!
      fill_in "Current password", with: @new_password
      click_on "Update"

      assert_text "Current password is invalid"
    end

    test "email change fails if old password is blank" do
      standard_password_edit_preconditions!
      fill_in "Current password", with: ""
      click_on "Update"

      assert_text "Current password can't be blank"
    end

    test "does not error out if old and new passwords idenitical" do
      standard_password_edit_preconditions!
      fill_in "Password", with: @current_password
      fill_in "Password confirmation", with: @current_password
      click_on "Update"
      assert_text "Your account has been updated successfully."
      welcome_page_logged_in_assertions!
    end

    ####################################################################
    #  Begin Helper Methods
    ####################################################################
    private

      # This method navigates you to the registrations#edit page and
      # sets up the state of the form to match it being filled out
      # correctly and just about to hit Update
      #
      # To test other scenarios, you call this method first to get the
      # form to the happy path state and then overwrite the specific
      # attributes you want to change with another fill_in call
      def standard_password_edit_preconditions!
        welcome_page_logged_in_assertions!
        click_on "Manage your account"
        registrations_edit_assertions!
        fill_in "Password", with: @new_password
        fill_in "Password confirmation", with: @new_password
        fill_in "Current password", with: @current_password
      end
  end
end
