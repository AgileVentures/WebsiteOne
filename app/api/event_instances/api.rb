module EventInstances
  class API < Grape::API
    helpers do
      params :pagination do
        optional :page, type: Integer
        optional :per_page, type: Integer
        optional :live, type: String
      end
    end
    version 'v1', using: :path, vendor: 'agileventures'
    format :json
    prefix :api

    resource :event_instances do
      desc 'Return the upcoming events.'
      params do 
        use :pagination
      end
      get '/' do
        relation = (params[:live] == 'true') ? EventInstance.live : EventInstance.latest
        @event_instances = relation.paginate(page: params[:page], per_page: 6)
        @event_instances
      end
    end
  end
end