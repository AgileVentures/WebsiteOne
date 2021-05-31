# frozen_string_literal: true

class AddTimezoneOffsetToUsers < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :timezone_offset, :integer
  end

  def down
    remove_column :users, :timezone_offset
  end
end
