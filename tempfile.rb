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

      def ordered_projects 
        Project.order('status ASC')
          .order('last_github_update DESC NULLS LAST')
          .order('commit_count DESC NULLS LAST')
          .includes(:user)
      end
    end

    resource :projects do
      desc 'Return projects list.'
      get '/' do
        projects_languages_hash = {}
        projects_followers_count = {}
        projects_documents_count = {}
        Project.all.each do |project|
          projects_languages_hash.merge!("#{project.title}": project.languages)
          projects_followers_count.merge!("#{project.title}": project.followers.count) 
          projects_documents_count.merge!("#{project.title}": project.documents.count)
        end
        { projects: ordered_projects, languages: projects_languages_hash, 
          followers: projects_followers_count, documents: projects_documents_count }
      end
    end
  end
end