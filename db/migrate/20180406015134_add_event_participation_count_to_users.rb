# frozen_string_literal: true

class AddEventParticipationCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :event_participation_count, :integer, default: 0
  end
end
