# NerdDice.com TailwindHelper
#
# The purpose of this helper is to have granular individual HTML classes
# available in the DOM so that we can manipulate them using Stimulus.
#
# This provides a workable middle ground during development where you
# don't lose the granularity of the individual classes like you would by
# using Tailwind Directives while still providing a Don't Repeat
# Yourself (DRY) framework for dealing with frequently reused sets of
# classes that can work together as UI components.
#
# In the future it might make sense to refactor out know immutable
# components into Tailwind Directives, but during early stage design and
# iteration, the Rails helper approach is easier to work with.
#
# TODO: The reusable component boundaries should end at the edge of the
# border margin and positioning should be handled by the particular view
# to allow for better flexibility for layout and positioning.
module TailwindHelper
  def tw_success_button
    join_classes(
      %w[font-semibold text-gray-100 bg-blue-500 hover:bg-blue-800 px-3 py-1 mt-1 mb-2 rounded-lg]
    )
  end

  def tw_cancel_button
    join_classes(
      %w[font-semibold text-gray-600 bg-gray-200 border-2 border-gray-500 hover:bg-gray-500 hover:text-gray-200 px-3
         py-1 mt-1 mb-2 rounded-lg]
    )
  end

  def tw_alert_button
    join_classes(
      %w[font-semibold text-gray-100 bg-red-500 border-2 border-red-500 hover:bg-gray-800 hover:text-gray-200 px-3 py-1
         mt-1 mb-2 rounded-lg]
    )
  end

  def tw_standard_link
    join_classes(%w[text-blue-600 hover:underline hover:text-blue-800 visited:text-purple-600])
  end

  def tw_h1
    join_classes(%w[font-bold text-4xl])
  end

  def tw_h2
    join_classes(%w[font-bold text-3xl])
  end

  # joins an array of classes with a space
  def join_classes(class_array)
    class_array.join(" ")
  end
end
