require_relative '../services/omniauth_request' #idk why i have to do this!

class UserAuthenticationsController < Devise::OmniauthCallbacksController
  before_filter :parse_request

  def parse_request
    @auth_request = ::OmniAuthRequest.new(request.env['omniauth.auth'])
    youtube if @auth_request.is_youtube?
  end

  def youtube
    unless current_user.youtube_id?
      youtube_id = Youtube.channel_id @auth_request.token
      current_user.update(youtube_id: youtube_id)
    end
    redirect_to(request.env['omniauth.origin'] || root_path)
  end

  def gplus  ; create ; end
  def github ; create ; end

  def create
    if auth = @auth_request.existing_authentication
      sign_in_with_existing_authentication(auth.user)
    elsif user = current_user || @auth_request.existing_user
      create_authentication_and_sign_in(user)
    else
      create_user_and_authentication_and_sign_in
    end
  end

  def destroy
    UserAuthentication.destroy_all(
      user_id: current_user.id,
      authentication_provider_id: @auth_request.provider.id
    )
    redirect_to edit_user_registration_path, notice: 'Successfully removed profile.'
  end

  private

  def create_user_and_authentication_and_sign_in
    user = @auth_request.new_user
    if user.valid?
      create_authentication_and_sign_in(user)
    else
      redirect_to new_user_registration_url, alert: user.errors.full_messages.first
    end
  end

  def create_authentication_and_sign_in(user)
    @auth_request.create_authentication(user)
    sign_in_with_existing_authentication(user)
  end

  def sign_in_with_existing_authentication(user)
    sign_in(:user, user)
    redirect_to root_path, notice: 'Signed in successfully.'
  end
end
