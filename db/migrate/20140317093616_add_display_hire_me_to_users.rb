class AddDisplayHireMeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :display_hire_me, :boolean
  end
end
