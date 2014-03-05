class AddYoutubeUserNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :youtube_user_name, :string
  end
end
