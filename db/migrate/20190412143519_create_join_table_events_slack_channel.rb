class CreateJoinTableEventsSlackChannel < ActiveRecord::Migration[5.2]
  def change
    create_join_table :events, :slack_channels do |t|
      t.index [:event_id, :slack_channel_id], name: "slack_event_channel", unique: true
      t.index [:slack_channel_id, :event_id], name: "slack_channel_name_event", unique: true
    end
  end
end
