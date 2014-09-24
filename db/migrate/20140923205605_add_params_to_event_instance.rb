class AddParamsToEventInstance < ActiveRecord::Migration
  def up
    add_column :event_instances, :start_planned, :datetime
    add_column :event_instances, :description, :string
    add_column :event_instances, :duration_planned, :integer
    add_column :event_instances, :start, :datetime
    add_column :event_instances, :heartbeat, :datetime
    EventInstance.reset_column_information

    EventInstance.all.each  { |event_instance|
      event_instance.start ||= event_instance.created_at
      event_instance.heartbeat ||= event_instance.updated_at
      event_instance.save!
    }
  end
  def down
    remove_column :event_instances, :start_planned
    remove_column :event_instances, :description
    remove_column :event_instances, :duration_planned
    remove_column :event_instances, :start
    remove_column :event_instances, :heartbeat
  end
end
