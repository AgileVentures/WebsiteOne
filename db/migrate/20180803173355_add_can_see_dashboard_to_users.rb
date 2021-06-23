# frozen_string_literal: true

class AddCanSeeDashboardToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :can_see_dashboard, :boolean, default: false
  end
end
