# frozen_string_literal: true

class AddAttributesToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :country_code, :string
    rename_column :users, :country, :country_name
  end
end
