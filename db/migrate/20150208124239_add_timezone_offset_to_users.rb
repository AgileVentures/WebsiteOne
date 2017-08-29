class AddTimezoneOffsetToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :timezone_offset, :integer
  end

  def down
    remove_column :users, :timezone_offset
  end
end
