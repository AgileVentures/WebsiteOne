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
        User.where.not(id: -1).includes(:karma, :titles)
        .order("karmas.total DESC")
        .limit(500)
      end

      def contributions(user) 
        user.commit_counts.select do |commit_count|
          commit_count.user.following? commit_count.project
        end
      end
    end

    resource :users do
      desc 'Return all users'
      get '/' do
        users_karma_total_hash = {}
        users_gravatar_url_hash = {}
        users_titles_hash = {}
        users_bio_hash = {}
        users_skill_list_hash = {}
        users_projects_list_hash = {}
        users_contributions_hash = {}
        User.includes(:karma, :titles).order("karmas.total DESC").limit(500).each do |user|
          users_karma_total_hash.merge!("#{user.id}": user.karma_total)
          users_gravatar_url_hash.merge!("#{user.id}": user.gravatar_url(size: 250))
          users_titles_hash.merge!("#{user.id}": user.titles.pluck(:name))
          users_bio_hash.merge!("#{user.id}": user.bio)
          users_skill_list_hash.merge!("#{user.id}": user.skill_list)
          users_projects_list_hash.merge!("#{user.id}": user.following_projects)
          users_contributions_hash.merge!("#{user.id}": contributions(user))
        end
        { 
          users: ordered_users, karma_total: users_karma_total_hash, gravatar_url: users_gravatar_url_hash, 
          users_title: users_titles_hash, users_bio: users_bio_hash, users_skills: users_skill_list_hash, 
          users_projects: users_projects_list_hash, users_contributions: users_contributions_hash
        }
      end
    end
  end
end