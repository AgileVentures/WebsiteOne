class AddReconfirmableToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :reconfirmable, :string
  end
end
