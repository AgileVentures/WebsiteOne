require 'hashie/mash'
require 'json'

module Gitter
  class Client
    module Messages

      def messages(room_id, options={})
        message_list = []
        self.class.get("/rooms/#{room_id}/chatMessages", headers: @headers, query: options).each do |message|
          message_list << Hashie::Mash.new(message)
        end
        message_list
      end

      def send_message(message, room_id)
        Hashie::Mash.new(self.class.post("/rooms/#{room_id}/chatMessages", headers: @headers, body: { text: message }.to_json ))
      end

      def update_message(message, room_id, chat_id)
        Hashie::Mash.new(self.class.put("/rooms/#{room_id}/chatMessages/#{chat_id}", headers: @headers, body: { text: message }.to_json ))
      end
    end
  end
end