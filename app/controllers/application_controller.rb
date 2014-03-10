require 'custom_errors.rb'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include CustomErrors::setup '404' => { template: 'pages/not_found' },
                              '500' => { template: 'pages/internal_error' },
                              'log-limit' => 5

  protected
  # overriding the devise sanitizer class to allow for custom fields to be permitted for mass assignment
  def devise_parameter_sanitizer
    if resource_class == User
      User::ParameterSanitizer.new(User, :user, params)
    else
      super
    end
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || root_path
  end

end
