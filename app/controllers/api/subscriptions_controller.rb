class Api::SubscriptionsController < ApplicationController
  respond_to :json

  before_action :authenticate_api!

  def authenticate_api!
    return true if authenticate_token
    render json: { errors: [ { detail: 'Access denied' } ] }, status: 401
  end

  # I want to have a version in the api http://localhost:3000/api/v1/subscriptions.json
  # like documentation in the tests
  # mention this in the README/SETUP ...

  api :GET, '/subscriptions.json', 'Get all subscribed Premium users'
  error :code => 401, :desc => 'Access denied; token required to access this endpoint'
  description 'Get a list of all Premium subscribed users and their start dates'
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
