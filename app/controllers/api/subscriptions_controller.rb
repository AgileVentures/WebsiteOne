class Api::SubscriptionsController < ApplicationController
	respond_to :json
  def index
    @subscriptions = Subscription.includes(:user).all
  end
end
