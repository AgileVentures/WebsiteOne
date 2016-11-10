require 'securerandom'
module EventInstancesHelper
  def generate_event_instance_id(user, project_id = nil)
    "#{user.id}#{project_id || '00'}-#{SecureRandom.uuid}"
  end
end
