class AddParticipantsToEventInstances < ActiveRecord::Migration[6.1]
  def change
    remove_column :event_instances, :participants, :text
    add_column :event_instances, :participants, :json, default: []
  end
end
