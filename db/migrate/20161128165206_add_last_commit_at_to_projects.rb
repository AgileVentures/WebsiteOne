class AddLastCommitAtToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :last_github_update, :datetime
  end
end
