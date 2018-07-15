class AvDashboardTokensController < ApplicationController
  require 'jwt'

  def create
    payload = { data: 'kitty' }
    @token = JWT.encode payload, nil, 'none'
  end
end
