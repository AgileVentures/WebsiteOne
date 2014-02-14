class AddYouTubeIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :youtube_id, :string
  end
end
