require "test_helper"

module TailwindHelper
  # Tests for the TailwindHelper::ButtonHelper methods
  # See ../tailwind_helper_test.rb for more info
  class ButtonHelperTest < ActionView::TestCase
    include TailwindHelper

    test "tw_base_button works as intended" do
      assert_equal "font-semibold px-3 py-1 rounded-lg", tw_base_button
    end

    test "tw_success_button works as intended" do
      assert_equal "font-semibold px-3 py-1 rounded-lg text-gray-100 bg-blue-500 hover:bg-blue-800",
                   tw_success_button
    end

    test "tw_cancel_button works as intended" do
      assert_equal "font-semibold px-3 py-1 rounded-lg text-gray-600 bg-gray-200 border-2 " \
                   "border-gray-500 hover:bg-gray-500 hover:text-gray-200",
                   tw_cancel_button
    end

    test "tw_alert_button works as intended" do
      assert_equal "font-semibold px-3 py-1 rounded-lg text-gray-100 bg-red-500 border-2 " \
                   "border-red-500 hover:bg-gray-800 hover:text-gray-200",
                   tw_alert_button
    end
  end
end
