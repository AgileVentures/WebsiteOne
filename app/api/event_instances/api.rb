# frozen_string_literal: true

module EventInstances
  class API < Grape::API
    version 'v1', using: :path, vendor: 'agileventures'
    format :json
    prefix :api

    resource :event_instances do
      desc 'Return the upcoming events.'
      get '/' do
        EventInstance.latest.limit(6)
      end
    end
  end
end
