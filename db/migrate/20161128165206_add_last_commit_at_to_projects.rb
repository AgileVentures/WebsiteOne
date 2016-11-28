class AddLastCommitAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :last_commit_at, :datetime
    add_column :projects, :last_commit_url, :string
  end
end
