class AddLastCommitAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :last_github_update, :datetime
  end
end
