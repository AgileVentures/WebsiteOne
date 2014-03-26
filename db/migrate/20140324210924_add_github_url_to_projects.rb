class AddGithubUrlToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :github_url, :string
  end
end
