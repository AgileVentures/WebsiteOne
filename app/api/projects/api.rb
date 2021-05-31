# frozen_string_literal: true

module Projects
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

    resource :projects do
      desc 'Return the upcoming events.'
      get '/' do
        Project.all
      end
    end
  end
end
