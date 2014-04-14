class AddEmailOptionToUser < ActiveRecord::Migration
  def change
    add_column :users, :receive_mailings, :boolean, default: true
  end
end
