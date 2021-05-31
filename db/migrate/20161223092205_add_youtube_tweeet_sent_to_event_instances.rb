# frozen_string_literal: true

class AddYoutubeTweeetSentToEventInstances < ActiveRecord::Migration[4.2]
  def change
    add_column :event_instances, :youtube_tweet_sent, :boolean, default: false
  end
end
