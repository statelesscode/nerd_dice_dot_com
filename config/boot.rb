ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

#
# NOTE:
# moved here, see explanation: https://github.com/simplecov-ruby/simplecov/issues/1082
#
# Require and start of SimpleCov MUST take place prior to requiring the
# application code
if ENV["COVERAGE"] || ENV["CI"]
  require "simplecov"

  # SimpleCov configuration for Rails and Coveralls
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
end
