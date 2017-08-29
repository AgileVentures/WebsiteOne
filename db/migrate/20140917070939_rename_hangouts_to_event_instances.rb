class RenameHangoutsToEventInstances < ActiveRecord::Migration[5.1]
  def change
    rename_table :hangouts, :event_instances
  end
end
