class AddExceptionsToEvents < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :exclusions, :text
    add_column :events, :exclusions, :json, default: []
  end
end
