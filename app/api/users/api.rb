# frozen_string_literal: true

module Users
  class API < Grape::API
    version 'v1', using: :path, vendor: 'agileventures'
    format :json
    prefix :api

    helpers do
      def current_user
        @current_user ||= User.authorize!(env)
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end

    resource :users do
      desc 'Return the upcoming events.'
      get '/' do
        User.all
      end
    end
  end
end
