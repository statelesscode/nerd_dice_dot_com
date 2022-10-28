ENV["RAILS_ENV"] ||= "test"

require "simplecov"

SimpleCov.start "rails" do
  if ENV["CI"]
    require "simplecov-lcov"

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = "coverage/lcov.info"
    end

    formatter SimpleCov::Formatter::LcovFormatter
  end
end

require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  # Helper methods defined in this class are available to all classes that
  # inherit from ActiveSupport::TestCase
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Need to update this if more user fixtures are added
    FIXTURE_USER_PASSWORDS = {
      "statelesscode@example.com" => "justaguy12345678",
      "dungeonmaster@example.com" => "TestPass5678",
      "rpgplayer@example.com" => "Other2468Password"
    }.freeze
    # Add more helper methods to be used by all tests here...

    # Run tests to ensure all fixtures are valid for a model.
    # Parameter is the class name as a constant (User, not "User")
    # Example:
    #   test "has valid fixtures" do
    #     run_model_fixture_tests User
    #   end
    #
    # Will print fixture and error message(s) upon failure
    def run_model_fixture_tests(klass_name)
      klass_name.all.each do |model_record|
        assert_predicate(
          model_record, :valid?,
          "Invalid #{klass_name} Fixture: #{model_record.inspect}\n\nErrors: #{model_record.errors.messages}"
        )
      end
    end
  end
end
