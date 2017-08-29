class ChangeColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :projects, :pitch, :text
  end
end
