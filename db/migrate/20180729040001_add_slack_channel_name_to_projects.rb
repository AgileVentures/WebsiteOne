# frozen_string_literal: true

class AddSlackChannelNameToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :slack_channel_name, :string
  end
end
