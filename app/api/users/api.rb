module Users
  class API < Grape::API
    version 'v1', using: :path, vendor: 'agileventures'
    format :json
    prefix :api

    helpers do
      def ordered_users 
        User.where.not(id: -1).includes(:karma)
        .order("karmas.total DESC")
        .limit(100)
      end

      def contributions(user) 
        user.commit_counts.select do |commit_count|
          commit_count.user.following? commit_count.project
        end
      end

      def videos(user) 
        EventInstance.where(user_id: user.id)
                     .order(created_at: :desc)
                     .limit(5)
      end
    end

    resource :users do
      desc 'Return all users'
      get '/' do
        users_karma_total_hash = {}
        users_gravatar_url_hash = {}

        User.includes(:karma).order("karmas.total DESC").limit(100).each do |user|
          users_karma_total_hash.merge!("#{user.id}": user.karma_total)
          users_gravatar_url_hash.merge!("#{user.id}": user.gravatar_url(size: 250))
        end
        { 
          users: ordered_users, 
          karma_total: users_karma_total_hash, 
          gravatar_url: users_gravatar_url_hash,
        }
      end
  
      desc 'Return a user show page info'
      params do
        requires :id, type: Integer, desc: 'User id.'
      end
      route_param :id do
        get do
          user = User.find(params[:id])
          {
            user: user,
            karmaTotal: user.karma_total, 
            gravatarUrl: user.gravatar_url(size: 250),
            bio: user.bio, 
            projects: user.following_projects, 
            contributions: contributions(user), 
            commitCountTotal: user.commit_count_total, 
            videos: videos(user),
            hangouts: user.number_hangouts_started_with_more_than_one_participant, 
            authentications: user.authentications.count, 
            profile: user.profile_completeness, 
            membershipLength: user.membership_length,
            activity: user.activity
          }
        end
      end
    end
  end
end