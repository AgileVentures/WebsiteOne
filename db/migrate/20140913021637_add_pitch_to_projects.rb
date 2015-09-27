class AddPitchToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :pitch, :string
  end
end
