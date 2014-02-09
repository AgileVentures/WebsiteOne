class AddDisplayProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :display_profile, :boolean, default: true
  end
end
