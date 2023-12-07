require 'hashie/mash'
require 'json'

module Gitter
  class Client
    module Users

      def current_user
        Hashie::Mash.new(self.class.get("/user", headers: @headers)[0])
      end

      def user_rooms(user_id)
        room_list = []
        self.class.get("/user/#{user_id}/rooms", headers: @headers).each do |room|
          room_list << Hashie::Mash.new(room)
        end
        room_list
      end

      def user_read_messages(user_id, room_id, chat_ids)
        Hashie::Mash.new(self.class.post("/user/#{user_id}/rooms/#{room_id}/unreadItems", headers: @headers, body: { chat: chat_ids }.to_json))
      end

      def user_orgs(user_id)
        org_list = []
        self.class.get("/user/#{user_id}/orgs", headers: @headers).each do |org|
          org_list << Hashie::Mash.new(org)
        end
        org_list
      end

      def user_repos(user_id)
        repo_list = []
        self.class.get("/user/#{user_id}/repos", headers: @headers).each do |repo|
          repo_list << Hashie::Mash.new(repo)
        end
        repo_list
      end

      def user_channels(user_id)
        channel_list = []
        self.class.get("/user/#{user_id}/channels", headers: @headers).each do |channel|
          channel_list << Hashie::Mash.new(channel)
        end
        channel_list
      end
    end
  end
end