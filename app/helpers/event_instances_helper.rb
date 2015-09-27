module EventInstancesHelper
  def generate_event_instance_id(user, project_id = nil)
    project_id ||= '00'
    "#{user.id}#{project_id}#{Time.now.to_i}"
  end
end
