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

  # disable due to no inputs
  # rubocop:disable Rails/OutputSafety
  def join_classes(class_array)
    class_array.join(" ").html_safe
  end
  # rubocop:enable Rails/OutputSafety
end
