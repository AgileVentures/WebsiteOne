class RenameHangoutsToEventInstances < ActiveRecord::Migration
  def change
    rename_table :hangouts, :event_instances
  end
end
