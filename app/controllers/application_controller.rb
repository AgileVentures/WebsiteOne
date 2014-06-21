require 'custom_errors.rb'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :static_page_path

  before_filter :get_next_event

  include ApplicationHelper
  include CustomErrors

  protected

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || root_path
  end

  private

  def get_next_event
    @next_event = Event.next_event_occurrence
  end
end
