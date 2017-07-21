class RemovePivotaltrackerIdFromProjects < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :pivotaltracker_id
  end
end
