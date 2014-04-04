class AddPivotaltrackerIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :pivotaltracker_id, :integer
  end
end
