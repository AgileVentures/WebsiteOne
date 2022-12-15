class ChangeParticipantsInEventInstances < ActiveRecord::Migration[6.1]
  def change
    change_column :event_instances, :participants, :json, default: []
  end
end
