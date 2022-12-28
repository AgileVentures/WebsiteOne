# frozen_string_literal: true

class AddCountryRegionCityToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :country, :string
    add_column :users, :city, :string
    add_column :users, :region, :string
  end
end
