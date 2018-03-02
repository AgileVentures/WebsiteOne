class AddForColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :for, :string
  end
end
