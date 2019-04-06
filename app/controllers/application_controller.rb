require 'custom_errors.rb'
require 'paypal.rb'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :static_page_path

  before_action :set_user_id
  before_action :get_next_scrum, :store_location, unless: -> { request.xhr? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :user_activity

  use_vanity :current_user

  include ApplicationHelper
  include CustomErrors

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys:[
      :first_name, :last_name, :email, :bio, :password,
      :password_confirmation, :current_password,
      :display_email, :display_profile, :display_hire_me,
      :receive_mailings, :status])
    
    modify_user_signup_params
  end

  def after_sign_in_path_for(resource)
    if resource.sign_in_count <= 1
      stored_location_for(resource) || '/getting-started'
    else
      stored_location_for(resource) || request.env['omniauth.origin'] || session[:previous_url] || root_path
    end
  end

  # see Settings.yml for privileged user
  #
  def check_privileged
    raise ::AgileVentures::AccessDenied.new(current_user, request) unless current_user.is_privileged?
  end

  rescue_from ::AgileVentures::AccessDenied do |exception|
    render file: "#{Rails.root}/public/403.html", status: 403, layout: false
  end

  private

  def request_path_blacklisted?
    paths = [
      user_session_path,
      new_user_registration_path,
      new_user_password_path,
      destroy_user_session_path,
      "#{edit_user_password_path}.*"
    ]

    paths.any?{ |path| request.original_fullpath =~ %r(#{path})}
  end

  def get_next_scrum
    @next_event = Event.next_occurrence(:Scrum) if Features.get_next_scrum.enabled
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if request.get? && !request_path_blacklisted?
      session[:previous_url] = request.original_fullpath
    end
  end

  def user_activity
    current_user.try :touch
  end
  
  def show_deactivated_message_and_redirect_to_root
    flash[:alert] = 'User is deactivated.'
    redirect_to root_path
  end
  
  def modify_user_signup_params
    devise_parameter_sanitizer.permit(:sign_up) do |user_signup_params|
      user_signup_params.permit(:receive_mailings)
      user_signup_params[:receive_mailings] = user_signup_params[:receive_mailings] == '1'
      user_signup_params.permit!
    end
  end

  # set current_user.id to a cookie to allow google analytics to access current_user var
  private

  def set_user_id
    cookies[:user_id] = current_user.id if current_user
  end

end
