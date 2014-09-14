class ChangeColumn < ActiveRecord::Migration
  def change
    change_column :projects, :pitch, :text
  end
end
