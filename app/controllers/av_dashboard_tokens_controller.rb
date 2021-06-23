# frozen_string_literal: true

class AvDashboardTokensController < ApplicationController
  require 'jwt'
  require 'date'

  before_action :authenticate_user!

  def create
    authorization_status = current_user.can_see_dashboard ? 'true' : 'false'
    expiration_timestamp = (DateTime.now + 1.day).strftime('%Q')
    payload = { authorized: authorization_status, exp: expiration_timestamp }
    @token = JWT.encode payload, Settings.av_dashboard_token_secret, 'HS256'
  end
end
