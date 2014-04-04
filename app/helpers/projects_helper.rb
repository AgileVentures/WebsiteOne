module ProjectsHelper
  def created_date
    date = @project.created_at.strftime('Created: %Y-%m-%d')
    (date)
  end
end
