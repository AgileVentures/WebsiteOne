class AddCategoryColumnToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :category, :string
  end
end
