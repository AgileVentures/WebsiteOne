class AddCountryRegionCityToUser < ActiveRecord::Migration
  def change
    add_column :users, :country, :string
    add_column :users, :city, :string
    add_column :users, :region, :string
  end
end
