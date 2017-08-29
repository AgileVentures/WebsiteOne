class AddDisplayEmailToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :display_email, :boolean
  end
end
