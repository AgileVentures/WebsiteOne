class AddExclusionsToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :exclusions, :text
  end
end
