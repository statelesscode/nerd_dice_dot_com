module TailwindHelper
  # NerdDice.com TailwindHelper::TypographyHelper
  #
  # This module is dedicated to styling for fonts, typography and elements
  # related to text.
  #
  # Follow the implementation pattern of refactoring out repeated classes
  # into sub-methods that can be reused when applicable.
  module TypographyHelper
    def tw_standard_link
      join_classes(%w[text-blue-600 hover:underline hover:text-blue-800 visited:text-purple-600])
    end

    def tw_h1
      join_classes(%w[font-bold text-4xl])
    end

    def tw_h2
      join_classes(%w[font-bold text-3xl])
    end
  end
end
