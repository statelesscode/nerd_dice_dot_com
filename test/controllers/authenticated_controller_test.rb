require "test_helper"

class AuthenticatedControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index if authenticated" do
    sign_in users(:player)
    get authenticated_url
    assert_response :success

    assert_select "p", "Back to welcome page"
    assert_select "button", "Log out"
  end

  test "should not get index if not authenticated" do
    get authenticated_url

    assert_redirected_to new_user_session_url
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end
end
