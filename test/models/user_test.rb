require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "has valid fixtures" do
    run_model_fixture_tests User
  end
end
