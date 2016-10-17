class AddHangoutParticipantsSnapshots < ActiveRecord::Migration
  def change
    create_table(:hangout_participants_snapshots) do |t|
      t.references :event_instance
      t.text :participants
    end
  end
end
