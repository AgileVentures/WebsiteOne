module Subscriptions
  class API < Grape::API
    version "v1", using: :path, vendor: "agileventures"
    format :json
    prefix :api

    helpers do
      def authenticate_api!
        error!('401 Unauthorized', 401) unless authenticate_token
        # render json: {errors: [{detail: "Access denied"}]}, status: 401
      end
      
      def authenticate_token
        authenticate_or_request_with_http_token do |token, _options|
         token == Settings.api.premium_subscriptions_token
        end
      end
    end

    resource :subscriptions do
      desc "Get a list of all Premium subscribed users and their start dates"
      get '/' do
        authenticate_api!
        @subscriptions = Subscription.includes(:user).joins(:payment_source).all
      end
    end
  end
end
