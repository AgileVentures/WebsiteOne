class AddYoutubeUserNameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :youtube_user_name, :string
  end
end
