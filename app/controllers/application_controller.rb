class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

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

  private

    def render_error(status, e)
      Rails.logger.error e.message
      e.backtrace.each { |line| Rails.logger.error line }
      case status
        when 404
          render template: 'pages/not_found', layout: 'layouts/application', status: 404

        when 500
          redirect_to '/internal_server_error'

        else
          logger.log('Unhandled exception???')
          redirect_to '/internal_server_error'
      end
    end
end
