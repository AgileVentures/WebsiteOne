module ProjectsHelper
  def created_by
    if @project.user_id.present?
      user = User.find_by_id(@project.user_id)
      if user.first_name.present?
        ['by:', ([user.first_name, user.last_name].join(' '))].join(' ')
      else
        ['by:', (user.email).split('@').first].join(' ')
      end
    else
      'No author'
    end
  end

  def created_date
    date = @project.created_at.strftime('Created: %Y-%m-%d')
    (date)
  end

end
