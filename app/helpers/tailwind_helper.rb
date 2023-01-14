# NerdDice.com TailwindHelper
#
# The purpose of this helper module is to have granular individual HTML
# classes available in the DOM so that we can manipulate them using Stimulus.
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
# IMPORTANT:
# The reusable component boundaries should always end at the edge of the
# border margin and positioning should be handled by the particular view
# to allow for better flexibility for layout and positioning.
#
# Individual themes of related functionality are in their own submodules
# which are included by this module.
module TailwindHelper
  include ButtonHelper
  include TypographyHelper

  # joins an array of classes with a space
  def join_classes(class_array)
    class_array.join(" ")
  end
end
