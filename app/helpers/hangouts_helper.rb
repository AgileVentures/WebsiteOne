module HangoutsHelper
  def generate_hangout_id(user, project = nil)
    project_id = project.try(:id) || '00'
    "#{user.id}#{project_id}#{Time.now.to_i}"
  end
end
