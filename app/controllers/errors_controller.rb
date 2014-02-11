class ErrorsController < ApplicationController

  public
  def not_found
    render template: 'pages/not_found', layout: 'layouts/application', status: 404
  end

  def internal_error
    render template: 'pages/internal_error', layout: 'layouts/application', status: 500
  end

end
