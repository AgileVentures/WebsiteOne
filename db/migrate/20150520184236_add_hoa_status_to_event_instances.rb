# frozen_string_literal: true

class AddHoaStatusToEventInstances < ActiveRecord::Migration[4.2]
  def change
    add_column :event_instances, :hoa_status, :string
    EventInstance.reset_column_information
    EventInstance.update_all(hoa_status: 'finished')
  end
end
