class AddKarmaToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :karma_points, :integer, default: 0
  end
end
