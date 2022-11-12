require "application_system_test_case"

module Devise
  ######################################################################
  # System test for user password and email change processes and error
  # handling.
  ######################################################################
  class ChangeEmailPasswordTest < ApplicationSystemTestCase
    setup do
      @user = users(:player)
      @current_password = FIXTURE_USER_PASSWORDS[@user.email]
      @new_password = "Gr@z'ztAby$s"
      login_with_user!(@user)
    end

    test "user can change password to another valid password" do
      standard_registrations_edit_preconditions!
      click_on "Update"
      assert_text "Your account has been updated successfully."
      welcome_page_logged_in_assertions!
    end

    test "provides error message if new password too short" do
      standard_registrations_edit_preconditions!
      fill_in "Password", with: "DWARF"
      fill_in "Password confirmation", with: "DWARF"
      click_on "Update"

      assert_text "Password is too short (minimum is 8 characters)"
    end

    test "provides error message if new password confirmation mismatch" do
      standard_registrations_edit_preconditions!
      fill_in "Password confirmation", with: "Asmodeus1337"
      click_on "Update"

      assert_text "Password confirmation doesn't match Password"
    end

    test "provides error message if old password is incorrect" do
      standard_registrations_edit_preconditions!
      fill_in "Current password", with: @new_password
      click_on "Update"

      assert_text "Current password is invalid"
    end

    test "does not error out if old and new passwords idenitical" do
      standard_registrations_edit_preconditions!
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

      def standard_registrations_edit_preconditions!
        welcome_page_logged_in_assertions!
        click_on "Manage your account"
        registrations_edit_assertions!
        fill_in "Password", with: @new_password
        fill_in "Password confirmation", with: @new_password
        fill_in "Current password", with: @current_password
      end

      def registrations_edit_assertions!
        assert_text "Edit User"
        assert_text "Email"
        assert_selector "input#user_email[value='#{@user.email}'"
        assert_text "Password (leave blank if you don't want to change it)"
        assert_text "8 characters minimum"
        assert_text "Password confirmation"
        assert_text "Current password"
        assert_text "(we need your current password to confirm your changes)"
        assert_text "Cancel my account"
        assert_text "Unhappy?"
      end
  end
end
