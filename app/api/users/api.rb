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
      desc 'Return all users'
      get '/' do
        users_karma_total_hash = {}
        users_gravatar_url_hash = {}
        User.limit(500).each do |user|
          users_karma_total_hash.merge!("#{user.id}": user.karma_total)
          users_gravatar_url_hash.merge!("#{user.id}": user.gravatar_url)
        end
        { users: User.limit(500), karma_total: users_karma_total_hash, gravatar_url: users_gravatar_url_hash }
      end
    end
  end
end