# frozen_string_literal: true

class AddCategoryToHangout < ActiveRecord::Migration[4.2]
  def change
    add_column :hangouts, :uid, :string
    add_column :hangouts, :category, :string
  end
end
