class AddDisplayProfileToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :display_profile, :boolean, default: true
  end
end
