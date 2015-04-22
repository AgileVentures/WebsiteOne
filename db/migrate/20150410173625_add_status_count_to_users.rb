class AddStatusCountToUsers < ActiveRecord::Migration
  def up
    add_column :users, :status_count, :integer, default: 0

    User.reset_column_information
    User.all.each do |user|
      User.reset_counters user.id, :status
    end
  end

  def down
    remove_column :users, :status_count
  end
end
