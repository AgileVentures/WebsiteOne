class AddPivotaltrackerUrlToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :pivotaltracker_url, :string
  end
end
