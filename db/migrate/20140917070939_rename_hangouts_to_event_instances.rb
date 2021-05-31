# frozen_string_literal: true

class RenameHangoutsToEventInstances < ActiveRecord::Migration[4.2]
  def change
    rename_table :hangouts, :event_instances
  end
end
