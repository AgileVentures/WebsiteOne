class RemoveKarmaFromUserTable < ActiveRecord::Migration
  def change
    remove_column :users, :karma_points, :integer
  end
end
