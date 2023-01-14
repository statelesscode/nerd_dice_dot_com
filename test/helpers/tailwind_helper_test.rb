require "test_helper"

# Tests for the TailwindHelper methods
#
# While these might seem a bit tedious and pointless, they are handy
# for ensuring that refactoring the Helpers produces the intended
# results.
#
# TailwindHelper is broken down into submodules the structure of the
# test classes should match the structure of the module files
class TailwindHelperTest < ActionView::TestCase
  test "join_classes works as expected" do
    assert_equal "foo bar baz", join_classes(%w[foo bar baz])
  end
end
