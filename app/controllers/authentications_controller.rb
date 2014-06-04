class AuthenticationsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  before_action :prevent_oauth_forgery, only: [:create]

  def create
    if authentication.present?
      login_with_oauth
    else
      CreateAuthenticationService.new(omniauth, current_user || User.new)
    end
  end

  def destroy
    if params[:id]=='youtube'
      unlink_from_youtube and return
    end

    @authentication = current_user.authentications.find(params[:id])
    if @authentication
      if current_user.authentications.count == 1 and current_user.encrypted_password.blank?
        # Bryan: TESTED
        flash[:alert] = 'Bad idea!'
      elsif @authentication.destroy
        flash[:notice] = 'Successfully removed profile.'
      else
        flash[:alert] = 'Authentication method could not be removed.'
      end
    else
      flash[:alert] = 'Authentication method not found.'
    end
    redirect_to edit_user_registration_path(current_user)
  end


  private

  def forged_request?
    (current_user && authentication) && authentication.user != current_user
  end

  def prevent_oauth_forgery
    return unless forged_request?
    flash[:alert] = 'Another account is already associated with these credentials!'
    redirect_to redirect_path
  end

  def redirect_path
    @path ||= request.env['omniauth.origin'] || root_path
  end

  def omniauth 
    @omniauth ||= request.env['omniauth.auth']
  end

  def authentication 
    @authentication ||= Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
  end

  def link_github_profile
    url = ''
    begin
      url = omniauth['info']['urls']['GitHub']
    rescue NoMethodError
      return
    end

    user = User.find(current_user.id)
    if user.update_attributes(github_profile_url: url)
      # success
      current_user.reload
    else
      flash[:alert] = 'Linking your GitHub profile has failed'
      Rails.logger.error user.errors.full_messages
    end
  end

  def link_to_youtube
    current_user.update_youtube_id_if(request.env['omniauth.auth']['credentials']['token'])
  end


  def unlink_from_youtube
    current_user.youtube_id = nil
    current_user.save

    redirect_to(params[:origin] || root_path)
  end

  def login_with_oauth
    flash[:notice] = 'Signed in successfully.'
    sign_in_and_redirect(:user, authentication.user)
  end
end
