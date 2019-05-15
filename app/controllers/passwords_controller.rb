class PasswordsController < Devise::PasswordsController
  # POST /resource/password
  def create
    self.resource = resource_class.find_by(email: params.dig(:user, :email))
    token = resource.send(:set_reset_password_token)

    if token
      render json: { success: true, token: token }, status: 200
    else
      render json: { success: false }, status: 422
    end
  end
end
