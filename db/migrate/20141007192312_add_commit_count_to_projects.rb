class AddCommitCountToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :commit_count, :integer, default: 0
  end
end
