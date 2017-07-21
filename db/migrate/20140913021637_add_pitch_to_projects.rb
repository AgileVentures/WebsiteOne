class AddPitchToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :pitch, :string
  end
end
