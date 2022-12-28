# frozen_string_literal: true

class RemoveKarmaFromUserTable < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :karma_points, :integer
  end
end
