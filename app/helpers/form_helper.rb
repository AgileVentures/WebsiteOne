module FormHelper
  def set_status(user)
    user.status ||= Status.new
  end
end