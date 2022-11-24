# Tests for the TailwindHelper methods
#
# While these might seem a bit tedious and pointless, they are handy
# for ensuring that refactoring the Helpers produces the intended
# results.
#
# In the event that the TailwindHelper is broken down into more modular
# code files, the tests should be restructured to match
class TailwindHelperTest < ActionView::TestCase
  test "tw_success_button works as intended" do
    assert_equal "font-semibold text-gray-100 bg-blue-500 hover:bg-blue-800 " \
                 "px-3 py-1 mt-1 mb-2 rounded-lg",
                 tw_success_button
  end

  test "tw_cancel_button works as intended" do
    assert_equal "font-semibold text-gray-600 bg-gray-200 border-2 border-gray-500 " \
                 "hover:bg-gray-500 hover:text-gray-200 px-3 py-1 mt-1 mb-2 rounded-lg",
                 tw_cancel_button
  end

  test "tw_alert_button works as intended" do
    assert_equal "font-semibold text-gray-100 bg-red-500 border-2 border-red-500 " \
                 "hover:bg-gray-800 hover:text-gray-200 px-3 py-1 mt-1 mb-2 rounded-lg",
                 tw_alert_button
  end

  test "tw_standard_link works as intended" do
    assert_equal "text-blue-600 hover:underline hover:text-blue-800 visited:text-purple-600", tw_standard_link
  end

  test "tw_h1 works as intended" do
    assert_equal "font-bold text-4xl", tw_h1
  end

  test "tw_h2 works as intended" do
    assert_equal "font-bold text-3xl", tw_h2
  end
end
