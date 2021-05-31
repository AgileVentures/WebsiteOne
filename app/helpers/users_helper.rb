# frozen_string_literal: true

module UsersHelper
  def activity_tab(param_tab)
    return 'active' if param_tab == 'activity'
  end

  def about_tab(param_tab)
    return 'active' unless param_tab == 'activity'
  end
end
