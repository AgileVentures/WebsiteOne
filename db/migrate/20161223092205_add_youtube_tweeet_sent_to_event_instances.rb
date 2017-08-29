class AddYoutubeTweeetSentToEventInstances < ActiveRecord::Migration[5.1]
  def change
    add_column :event_instances, :youtube_tweet_sent, :boolean, default: false
  end
end
