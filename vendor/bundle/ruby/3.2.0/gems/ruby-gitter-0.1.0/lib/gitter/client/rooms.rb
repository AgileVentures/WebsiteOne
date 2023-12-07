require 'hashie/mash'

module Gitter
  class Client
    module Rooms
      def rooms
        room_list = []
        self.class.get("/rooms", headers: @headers).each do |room|
          room_list << Hashie::Mash.new(room)
        end
        room_list
      end

      def room_users(room_id)
        user_list = []
        self.class.get("/rooms/#{room_id}/users", headers: @headers).each do |user|
          user_list << Hashie::Mash.new(user)
        end
        user_list
      end

      def room_channels(room_id)
        channel_list = []
        self.class.get("/rooms/#{room_id}/channels", headers: @headers).each do |channel|
          channel_list << Hashie::Mash.new(channel)
        end
        channel_list
      end

      def join_room(uri)
        Hashie::Mash.new(self.class.post("/rooms", headers: @headers, query: { uri: uri } ))
      end
    end
  end
end