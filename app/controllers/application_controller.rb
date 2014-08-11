require 'custom_errors.rb'

class ApplicationController < ActionController::Base
  include YoutubeHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :static_page_path

  before_filter :get_next_event
  before_action :configure_permitted_parameters, if: :devise_controller?

  include ApplicationHelper
  include CustomErrors

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name, :email, :bio, :password,
               :password_confirmation, :current_password,
               :display_email, :display_profile, :display_hire_me,
               :receive_mailings)
    end
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || root_path
  end

  private

  def get_next_event
    @next_event = Event.next_event_occurrence
  end
end
