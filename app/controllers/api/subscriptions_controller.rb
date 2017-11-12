class Api::SubscriptionsController < ApplicationController
	respond_to :json

  before_action :authenticate_api!

  def authenticate_api!
    return true if authenticate_token
    render json: { errors: [ { detail: "Access denied" } ] }, status: 401
  end

  def index
    @subscriptions = Subscription.includes(:user).all
  end

  private
  def authenticate_token
    debugger
    authenticate_with_http_token do |token, options|
      debugger
      token == Api.premium_subscriptions_api_token
    end
  end
end
