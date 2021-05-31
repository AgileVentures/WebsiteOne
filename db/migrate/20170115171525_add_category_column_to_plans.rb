# frozen_string_literal: true

class AddCategoryColumnToPlans < ActiveRecord::Migration[4.2]
  def change
    add_column :plans, :category, :string
  end
end
