require 'custom_errors.rb'

class ApplicationController < ActionController::Base
  include YoutubeHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :static_page_path

  before_filter :get_next_scrum, :store_location, unless: -> { request.xhr? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_filter :user_activity

  include ApplicationHelper
  include CustomErrors

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name, :email, :bio, :password,
               :password_confirmation, :current_password,
               :display_email, :display_profile, :display_hire_me,
               :receive_mailings, :status)
    end
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || session[:previous_url] || root_path
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
    @next_event = Event.next_occurrence(:Scrum)
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

end
