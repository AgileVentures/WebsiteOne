# frozen_string_literal: true

# require 'airbrake'

module CustomErrors
  def self.included(base)
    base.rescue_from Exception, with: ->(exception) { render_error 500, exception }

    base.rescue_from ActionController::RoutingError,
                     #  ActionController::UnknownController,
                     AbstractController::ActionNotFound,
                     ActiveRecord::RecordNotFound,
                     with: ->(exception) { render_error 404, exception }
  end

  private

  def render_error(status, error)
    raise error unless Features.enabled?(:custom_errors)

    Rails.logger.error error.message
    error.backtrace.each_with_index do |line, index|
      Rails.logger.error line
      break if index >= 5
    end

    # unless [404].include? status
    #   if Rails.env.production?
    #     notice = Airbrake.build_notice(error)
    #     notice.stash[:rack_request] = Rails.env['grape.request']
    #     Airbrake.notify(notice)
    #   else
    #     ExceptionNotifier.notify_exception(error, env: request.env, data: { message: 'was doing something wrong' })
    #   end
    # end
    ExceptionNotifier.notify_exception(error, env: request.env, data: { message: 'was doing something wrong' })
    case status
    when 404
      render template: 'static_pages/not_found', layout: 'layouts/application', status: :not_found, formats: [:html]

    when 500
      render template: 'static_pages/internal_error', layout: 'layouts/application', status: :internal_server_error,
             formats: [:html]

    else
      render template: 'static_pages/internal_error', layout: 'layouts/application', status: :internal_server_error,
             formats: [:html]
    end
  end
end
