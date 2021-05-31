# frozen_string_literal: true

class AddDisplayEmailToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :display_email, :boolean
  end
end
