# frozen_string_literal: true

class AddLastCommitAtToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :last_github_update, :datetime
  end
end
