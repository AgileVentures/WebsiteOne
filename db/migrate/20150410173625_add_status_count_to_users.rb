class AddStatusCountToUsers < ActiveRecord::Migration
  def up
    add_column :users, :status_count, :integer, default: 0
    User.all.each do |user|
      user.update_attribute :status_count, user.status.count
    end
  end

  def down
    remove_column :users, :status_count
  end
end
