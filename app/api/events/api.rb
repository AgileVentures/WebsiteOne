module Events
    class API < Grape::API
      version 'v1', using: :header, vendor: 'agileventures'
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
  
      resource :events do
        desc 'Return a public timeline.'
        get :upcoming do
            Event.upcoming_events(nil)
        end
      end
    end
  end