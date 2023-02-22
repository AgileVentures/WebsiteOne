class ChangeParticipantsInEventInstances < ActiveRecord::Migration[6.1]
  def change
    change_column :event_instances, :participants, "json USING CAST(participants AS json)"
    change_column_default :event_instances, :participants, []
  end
end
