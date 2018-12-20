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

      def ordered_users 
        User.includes(:karma, :titles)
        .order("karmas.total DESC")
        .limit(500)
      end
    end

    resource :users do
      desc 'Return all users'
      get '/' do
        users_karma_total_hash = {}
        users_gravatar_url_hash = {}
        users_titles_hash = {}
        User.includes(:karma, :titles).order("karmas.total DESC").limit(500).each do |user|
          users_karma_total_hash.merge!("#{user.id}": user.karma_total)
          users_gravatar_url_hash.merge!("#{user.id}": user.gravatar_url)
          users_titles_hash.merge!("#{user.id}": user.titles.pluck(:name))
        end
        { users: ordered_users, karma_total: users_karma_total_hash, gravatar_url: users_gravatar_url_hash, users_title: users_titles_hash }
      end
    end
  end
end