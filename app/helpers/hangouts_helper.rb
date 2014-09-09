module HangoutsHelper
  def generate_hangout_id(user, project_id = nil)
    project_id ||= '00'
    "#{user.id}#{project_id}#{Time.now.to_i}"
  end
end
