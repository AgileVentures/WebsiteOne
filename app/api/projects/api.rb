module Projects
  class API < Grape::API
    version 'v1', using: :path, vendor: 'agileventures'
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers
    prefix :api

    helpers do
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
        ordered_projects
      end

      desc 'Return all active projects'
      get :active do
        Project.active
      end
      
      desc "Return a project's languages"
      get :languages do
        projects_languages_hash = {}
        Project.all.each do |project|
          projects_languages_hash.merge!("#{project.title}": project.languages)
        end
        { languages: projects_languages_hash }
      end
      
      desc 'Return a projects show page info'
      params do
        requires :slug, type: String, desc: 'Project slug.'
      end
      route_param :slug do
        get do
          project = Project.find_by(slug: params[:slug])
          users_gravatar_url_hash = {}
          project.members.first(5).reverse_each do |member|
            users_gravatar_url_hash.merge!("#{member.slug}": member.gravatar_url(size: 32))
          end
          { 
            project: project,
            projectManager: project.user.display_name,
            sourceRepositories: project.source_repositories,
            members: project.members.first(5).reverse,
            membersGravatarUrl: users_gravatar_url_hash,
            videos: project.event_instances.latest.limit(5)
          }
        end  
      end
    end
  end
end