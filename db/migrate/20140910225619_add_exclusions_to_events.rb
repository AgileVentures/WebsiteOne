class AddExclusionsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :exclusions, :text
  end
end
