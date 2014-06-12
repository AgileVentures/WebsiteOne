# overriding the devise sanitizer class to allow for custom fields to be permitted for mass assignment
class User::ParameterSanitizer < Devise::ParameterSanitizer
  private
  def account_update
    default_params.permit(:first_name, :last_name, :email, :bio, :password, :password_confirmation, :current_password,
                          :display_email, :display_profile, :display_hire_me, :receive_mailings)
  end
end
