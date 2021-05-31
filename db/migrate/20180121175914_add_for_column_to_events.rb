# frozen_string_literal: true

class AddForColumnToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :for, :string
  end
end
