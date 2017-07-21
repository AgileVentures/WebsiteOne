class AddCategoryToHangout < ActiveRecord::Migration[5.1]
  def change
    add_column :hangouts, :uid, :string
    add_column :hangouts, :category, :string
  end
end
