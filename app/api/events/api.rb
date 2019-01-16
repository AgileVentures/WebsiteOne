module Events
  class API < Grape::API
    version 'v1', using: :path, vendor: 'agileventures'
    format :json
    prefix :api

    resource :events do
      desc 'Return the upcoming events.'
      get :upcoming do
        Event.upcoming_events(nil)
      end
    end
  end
end