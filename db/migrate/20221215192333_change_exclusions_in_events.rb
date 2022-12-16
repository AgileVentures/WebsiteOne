class ChangeExclusionsInEvents < ActiveRecord::Migration[6.1]
  def change
    change_column :events, :exclusions, "json USING CAST(exclusions AS json)"
    change_column_default :events, :exclusions, []
  end
end
