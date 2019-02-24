module Events
  class API < Grape::API
    version 'v1', using: :path, vendor: 'agileventures'
    format :json
    prefix :api

    helpers do
      def event_creator(event)
        event.creator_id.present? ? User.find(event.creator_id).display_name : nil
      end
      
      def event_modifier(event)
        event.modifier_id.present? ? User.find(event.modifier_id).display_name : nil
      end
    end

    resource :events do
      desc 'Return the upcoming events.'
      get :upcoming do
        Event.upcoming_events(nil)
      end

      desc 'Return a event show page info'
      params do
        requires :slug, type: String, desc: 'Event info page'
      end
      route_param :slug do
        get do
          event = Event.find_by(slug: params[:slug])
          {
            event: event,
            creator: event_creator(event),
            modifier: event_modifier(event)
          }
        end
      end

    end
  end
end