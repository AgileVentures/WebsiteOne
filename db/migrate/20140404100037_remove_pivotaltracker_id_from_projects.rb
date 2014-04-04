class RemovePivotaltrackerIdFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :pivotaltracker_id
  end
end
