class AddYouTubeIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :youtube_id, :string
  end
end
