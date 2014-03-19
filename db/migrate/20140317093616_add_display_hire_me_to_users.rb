class AddDisplayHireMeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :display_hire_me, :boolean
  end
end
