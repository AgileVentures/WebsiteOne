class AuthenticationsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]

  def create
    if current_user
      if authentication.present? and authentication.user != current_user
        flash[:alert] = 'Another account is already associated with these credentials!'
        redirect_to redirect_path
      else
        create_new_authentication_for_current_user(redirect_path)
      end
    else
      if authentication.present?
        attempt_login_with_auth(redirect_path)
      else
        create_new_user_with_authentication
      end
    end
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

  def failure
    # Bryan: TESTED
    flash[:alert] = 'Authentication failed.'
    redirect_to root_path
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

  def attempt_login_with_auth(path)
    flash[:notice] = 'Signed in successfully.'
    sign_in_and_redirect(:user, authentication.user)
  end

  def create_authentication_for_user
    current_user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid']).save
  end

  def create_new_authentication_for_current_user(path)
    if create_authentication_for_user
      # Bryan: TESTED
      flash[:notice] = 'Authentication successful.'
      redirect_to path
    else
      # Bryan: TESTED
      flash[:alert] = 'Unable to create additional profiles.'
      redirect_to redirect_path
    end
    if omniauth['provider']=='github' && current_user.github_profile_url.blank?
      link_github_profile
    elsif request.env['omniauth.params']['youtube']
      link_to_youtube
    end
  end

  def create_new_user_with_authentication
    user = User.new
    user.apply_omniauth(omniauth)

    if user.save
      # Bryan: TESTED
      Mailer.send_welcome_message(user).deliver
      flash[:notice] = 'Signed in successfully.'
      sign_in_and_redirect(:user, user)
    else
      # Bryan: TESTED
      session[:omniauth] = omniauth.except('extra')
      redirect_to new_user_registration_url
    end
  end
end











