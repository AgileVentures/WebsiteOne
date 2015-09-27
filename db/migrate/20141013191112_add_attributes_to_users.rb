class AddAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :country_code, :string
    rename_column :users, :country, :country_name
  end
end
