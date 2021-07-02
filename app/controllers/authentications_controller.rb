# frozen_string_literal: true

class AuthenticationsController < ApplicationController
  include DeactivatedUserFinder

  before_action :authenticate_user!, only: [:destroy]

  def create
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    @path = request.env['omniauth.origin'] || root_path
    if authentication.present?
      attempt_login_with_auth(authentication, @path)
    elsif current_user
      create_new_authentication_for_current_user(omniauth, @path)
    elsif deactivated_user_with_email(omniauth['info']['email']).present?
      show_deactivated_message_and_redirect_to_root and return
    else
      create_new_user_with_authentication(omniauth)
    end
    link_github_profile if current_user && omniauth['provider'] == 'github' && current_user.github_profile_url.blank?
  end

  def failure
    flash[:alert] = params[:message] || 'Authentication failed.'
    redirect_to root_path
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    if @authentication && (current_user.authentications.count == 1) && current_user.encrypted_password.blank?
      flash[:alert] = 'Failed to unlink GitHub. Please use another provider for login or reset password.'
    elsif @authentication&.destroy
      user = User.find(current_user.id)
      flash[:notice] = if user.update(github_profile_url: nil)
                         'Successfully removed profile.'
                       else
                         'Github profile url could not be removed.'
                       end
    else
      flash[:alert] = 'Authentication method could not be removed.'
    end
    redirect_to edit_user_registration_path(current_user)
  end

  private

  def link_github_profile
    omniauth = request.env['omniauth.auth']

    url = ''
    begin
      url = omniauth['info']['urls']['GitHub']
    rescue NoMethodError
      return
    end

    user = User.find(current_user.id)
    if user.update(github_profile_url: url)
      # success
      current_user.reload
    else
      flash[:alert] = 'Linking your GitHub profile has failed'
      Rails.logger.error user.errors.full_messages
    end
  end

  def attempt_login_with_auth(authentication, path)
    if current_user.present? && (authentication.user != current_user)
      flash[:alert] = 'Another account is already associated with these credentials!'
      redirect_to path
    else
      flash[:notice] = 'Signed in successfully.'
      sign_in_and_redirect(:user, authentication.user)
    end
  end

  def create_new_authentication_for_current_user(omniauth, path)
    if auth = current_user.authentications.build(provider: omniauth['provider'], uid: omniauth['uid'])
      if auth.save
        # Bryan: TESTED
        flash[:notice] = 'Authentication successful.'
        redirect_to path
      else
        # Bryan: TESTED
        flash[:alert] = 'Unable to create additional profiles.'
        redirect_to @path
      end
    end
  end

  def create_new_user_with_authentication(omniauth)
    user = User.new(karma: Karma.new)
    user.apply_omniauth(omniauth)

    if user.save
      # Bryan: TESTED
      # Vanity.track!(:signups)
      Mailer.send_welcome_message(user).deliver_now if Features.enabled?(:welcome_email)
      flash[:notice] = 'Signed in successfully.'
      flash[:user_signup] = 'Signed up successfully.'
      sign_in_and_redirect(:user, user)
    else
      # Bryan: TESTED
      session[:omniauth] = omniauth.except('extra')
      redirect_to new_user_registration_url
    end
  end
end
