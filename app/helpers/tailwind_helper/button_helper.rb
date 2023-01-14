module TailwindHelper
  # NerdDice.com TailwindHelper::ButtonHelper
  #
  # This module is dedicated to styling for buttons.
  # If changes should apply to all buttons, the tw_base_button method should be modified
  #
  # Follow the implementation pattern of combining tw_base_button with the additional
  # tailwind classes needed.
  module ButtonHelper
    def tw_base_button
      join_classes(
        %w[font-semibold px-3 py-1 rounded-lg]
      )
    end

    def tw_success_button
      "#{tw_base_button} #{join_classes(
        %w[text-gray-100 bg-blue-500 hover:bg-blue-800]
      )}"
    end

    def tw_cancel_button
      "#{tw_base_button} #{join_classes(
        %w[text-gray-600 bg-gray-200 border-2 border-gray-500 hover:bg-gray-500 hover:text-gray-200]
      )}"
    end

    def tw_alert_button
      "#{tw_base_button} #{join_classes(
        %w[text-gray-100 bg-red-500 border-2 border-red-500 hover:bg-gray-800 hover:text-gray-200]
      )}"
    end
  end
end
