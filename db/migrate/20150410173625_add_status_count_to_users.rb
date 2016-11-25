class AddStatusCountToUsers < ActiveRecord::Migration
  def up
    add_column :users, :status_count, :integer, default: 0
  end

  def down
    remove_column :users, :status_count
  end
end
