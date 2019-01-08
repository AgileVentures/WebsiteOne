class CreateJoinTableProjectSlackChannel < ActiveRecord::Migration[5.2]
  def change
    create_join_table :projects, :slack_channels do |t|
      t.index [:project_id, :slack_channel_id], name: "slack_project_channel", unique: true
      t.index [:slack_channel_id, :project_id], name: "slack_channel_name", unique: true
    end
  end
end
