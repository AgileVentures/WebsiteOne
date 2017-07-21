class RemoveKarmaFromUserTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :karma_points, :integer
  end
end
