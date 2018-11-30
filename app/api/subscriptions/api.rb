module Subscriptions
  class API < Grape::API
    version 'v1', using: :path, vendor: 'agileventures'
    format :json
    prefix :api

    helpers do
      def authenticate_token
        authenticate_or_request_with_http_token do |token, _options|
          token == Settings.api.premium_subscriptions_token
        end
      end
      def authenticate_api!
        return true if authenticate_token
        render json: { errors: [ { detail: 'Access denied' } ] }, status: 401
      end
    end

    resource :subscriptions do
      desc 'Return the upcoming events.'
      get :upcoming do
        authenticate_api!
        Subscription.includes(:user).joins(:payment_source).all
      end
    end
  end
end

# I want to have a version in the api http://localhost:3000/api/v1/subscriptions.json
# like documentation in the tests
# mention this in the README/SETUP ...

#api :GET, '/subscriptions.json', 'Get all subscribed Premium users'
#error :code => 401, :desc => 'Access denied; token required to access this endpoint'
#description 'Get a list of all Premium subscribed users and their start dates'
