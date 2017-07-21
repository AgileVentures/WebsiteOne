class AddHangoutParticipantsSnapshots < ActiveRecord::Migration[5.1]
  def change
    create_table(:hangout_participants_snapshots) do |t|
      t.references :event_instance
      t.text :participants
    end
  end
end
