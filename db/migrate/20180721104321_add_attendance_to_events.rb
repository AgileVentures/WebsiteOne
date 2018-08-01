class AddAttendanceToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :attendance, :boolean, default: true
  end
end
