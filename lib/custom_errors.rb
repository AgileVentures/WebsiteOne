module CustomErrors

  def self.included(base)
    base.rescue_from Exception, with: ->(exception) { render_error 500, exception }

    base.rescue_from ActionController::RoutingError,
                     ActionController::UnknownController,
                     AbstractController::ActionNotFound,
                     ActiveRecord::RecordNotFound,
                     with: ->(exception) { render_error 404, exception }
  end

  private

  # PRIVATE
  def render_error(status, error)
    puts request.format
    raise error unless Rails.env.production?

    Rails.logger.error error.message
    error.backtrace.each_with_index { |line, index| Rails.logger.error line; break if index >= 5 }

    unless [ 404 ].include? status
      ExceptionNotifier.notify_exception(error, env: request.env, :data => { message: 'was doing something wrong' })
    end

    request_format = request.format.split('/').last
    case status
      when 404
        render 'static_pages/not_found', layout: 'layouts/application', status: 404, format: [request_format]

      when 500
        render 'static_pages/internal_error', layout: 'layouts/application', status: 500, format: [request_format]

      else
        render 'static_pages/internal_error', layout: 'layouts/application', status: 500, format: [request_format]
    end
  end
end
