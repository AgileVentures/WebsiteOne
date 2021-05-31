# frozen_string_literal: true

class AddDisplayHireMeToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :display_hire_me, :boolean
  end
end
