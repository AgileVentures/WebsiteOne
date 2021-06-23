# frozen_string_literal: true

class AddProjectAndHostToHangout < ActiveRecord::Migration[4.2]
  def change
    add_column :hangouts, :project_id, :integer
    add_column :hangouts, :user_id, :integer
    add_column :hangouts, :yt_video_id, :string
    add_column :hangouts, :participants, :text
  end
end
