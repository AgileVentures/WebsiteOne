# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  include DeactivatedUserFinder

  layout 'layouts/user_profile_layout', only: [:edit]
  prepend_before_action :check_for_deactivated_user, only: [:create]
  prepend_before_action :check_captcha, only: [:create]

  def create
    super
    unless @user.new_record?
      session[:omniauth] = nil
      flash[:user_signup] = 'Signed up successfully.'
      Vanity.track!(:signups)
      Mailer.send_welcome_message(@user).deliver_now if Features.enabled?(:welcome_email)
    end
  end

  def update
    if params[:preview]
      resource.display_email = params[:user][:display_email] == '1'
      render action: 'edit'
    else
      @user = User.friendly.find(current_user.friendly_id)
      @user.skill_list = params[:user].delete 'skill_list' # Extracts skills from params
      account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

      if @user.update(account_update_params)
        set_flash_message :notice, :updated
        redirect_to after_update_path_for(@user)
      else
        render :edit
      end
    end
  end

  private

  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new sign_up_params
      resource.validate # Look for any other validation errors besides Recaptcha
      respond_with_navigational(resource) { render :new }
    end
  end

  def build_resource(hash = {})
    hash.merge!({ karma: Karma.new })
    self.resource = User.new_with_session(hash, session)
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

  def after_sign_up_path_for(_resource)
    '/getting-started'
  end

  def fetch_email_from_params
    params.fetch(:user, {}).fetch(:email, '')
  end

  def check_for_deactivated_user
    show_deactivated_message_and_redirect_to_root if deactivated_user_with_email(fetch_email_from_params).present?
  end
end
