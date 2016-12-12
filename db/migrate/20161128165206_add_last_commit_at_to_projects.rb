class AddLastCommitAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :last_update_at, :datetime
  end
end
