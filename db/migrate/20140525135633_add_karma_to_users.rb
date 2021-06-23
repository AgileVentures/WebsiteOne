# frozen_string_literal: true

class AddKarmaToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :karma_points, :integer, default: 0
  end
end
