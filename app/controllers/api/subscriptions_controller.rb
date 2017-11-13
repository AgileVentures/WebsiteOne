class Api::SubscriptionsController < ApplicationController
  respond_to :json

  before_action :authenticate_api!


  def authenticate_api!
    return true if authenticate_token
    render json: { errors: [ { detail: "Access denied" } ] }, status: 401
  end

  def index
    @subscriptions = Subscription.includes(:user).joins(:payment_source).all
  end

  private
  def authenticate_token
    authenticate_or_request_with_http_token do |token, _options|
      token == Settings.api.premium_subscriptions_token
    end
  end
end
