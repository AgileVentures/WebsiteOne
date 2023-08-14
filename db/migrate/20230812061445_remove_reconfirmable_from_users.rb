class RemoveReconfirmableFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :reconfirmable, :string
  end
end
