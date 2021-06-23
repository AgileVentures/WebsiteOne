# frozen_string_literal: true

class AddEmailOptionToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :receive_mailings, :boolean, default: true
  end
end
