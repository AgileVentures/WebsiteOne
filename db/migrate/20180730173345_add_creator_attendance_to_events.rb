class AddCreatorAttendanceToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :creator_attendance, :boolean, default: true
  end
end
