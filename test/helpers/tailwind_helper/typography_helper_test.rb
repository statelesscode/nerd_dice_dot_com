require "test_helper"

module TailwindHelper
  # Tests for the TailwindHelper::ButtonHelper methods
  # See ../tailwind_helper_test.rb for more info
  class TypographyHelperTest < ActionView::TestCase
    include TailwindHelper

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
end
