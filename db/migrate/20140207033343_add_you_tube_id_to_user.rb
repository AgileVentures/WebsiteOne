# frozen_string_literal: true

class AddYouTubeIdToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :youtube_id, :string
  end
end
