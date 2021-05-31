# frozen_string_literal: true

class AddYoutubeUserNameToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :youtube_user_name, :string
  end
end
