class AddCategoryToHangout < ActiveRecord::Migration
  def change
    add_column :hangouts, :uid, :string
    add_column :hangouts, :category, :string
  end
end
