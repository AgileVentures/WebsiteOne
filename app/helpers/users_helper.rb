module UsersHelper

  def activity_tab(param_tab)
    return 'active' if param_tab == "activity"
  end

  def about_tab(param_tab)
    return 'active' unless param_tab == "activity"
  end
  
  def deactivated_user_with_email(email)
    User.only_deleted.where(email: email).first
  end
end
