require "test_helper"

# Tests for the WelcomeController
#
# Makes assertions about both the authenticated and non-authenticated
# behavior
class WelcomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index for non-logged in user" do
    get welcome_url

    assert_response :success

    assert_select "h1", "Nerd Dice"
    # has non-logged-in attriutes
    assert_select "p", "Sign up"
    assert_select "p", "Log in"
    # does not have logged in attributes
    assert_no_match "Visit the members' area", response.body
    assert_no_match "Log out", response.body
  end

  test "should get index for logged in user" do
    sign_in users(:dm)
    get welcome_url

    assert_response :success

    assert_select "h1", "Nerd Dice"
    #  has logged in attributes
    assert_select "p", "Visit the members' area"
    assert_select "button", "Log out"

    # does not have non-logged-in attriutes
    assert_no_match "Sign up", response.body
    assert_no_match "Log in", response.body
  end
end
