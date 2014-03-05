class ErrorsController < ApplicationController

  def not_found
    render template: 'pages/not_found', layout: 'layouts/application', status: 404
  end

end
