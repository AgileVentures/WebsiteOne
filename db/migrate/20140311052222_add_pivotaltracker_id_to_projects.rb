class AddPivotaltrackerIdToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :pivotaltracker_id, :integer
  end
end
