module ProjectsHelper
  def created_date
    @project.created_at.strftime('Created: %Y-%m-%d')
  end
end
