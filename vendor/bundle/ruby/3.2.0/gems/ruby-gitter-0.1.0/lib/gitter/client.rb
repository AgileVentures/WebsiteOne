require "httparty"
require "gitter/client/rooms"
require "gitter/client/messages"
require "gitter/client/users"

module Gitter
  class Client
    include HTTParty
    include Gitter::Client::Rooms
    include Gitter::Client::Messages
    include Gitter::Client::Users

    base_uri "https://api.gitter.im/v1"

    def initialize(token)
      @headers =  {
                    "Content-Type" => "application/json",
                    "Accept" => "application/json",
                    "Authorization" => "Bearer #{token}"
                  }
    end
  end
end