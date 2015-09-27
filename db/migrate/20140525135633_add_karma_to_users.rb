class AddKarmaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :karma_points, :integer, default: 0
  end
end
