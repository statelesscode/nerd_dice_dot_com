require "test_helper"

# Tests for the User model
class UserTest < ActiveSupport::TestCase
  # tests that all the current fixtures are valid model objects
  test "has valid fixtures" do
    run_model_fixture_tests User
  end
end
