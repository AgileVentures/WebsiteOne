# frozen_string_literal: true

class AddDisplayProfileToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :display_profile, :boolean, default: true
  end
end
