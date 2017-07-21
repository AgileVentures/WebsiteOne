class AddAttributesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :country_code, :string
    rename_column :users, :country, :country_name
  end
end
