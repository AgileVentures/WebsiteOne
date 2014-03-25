class AddPivotaltrackerUrlToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :pivotaltracker_url, :string
  end
end
