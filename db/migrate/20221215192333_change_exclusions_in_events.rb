class ChangeExclusionsInEvents < ActiveRecord::Migration[6.1]
  def change
    change_column :events, :exclusions, :json, default: []
  end
end
