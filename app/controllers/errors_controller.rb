class ErrorsController < ApplicationController

  def not_found
    render template: 'pages/not_found', layout: 'layouts/application', status: 404
    #render :status => 404}
  end

  def unacceptable
    render template: 'errors/unacceptable', layout: 'layouts/application', status: 422
  end

  def internal_error
    render template: 'errors/internal_error', layout: 'layouts/application', status: 500
  end

end
