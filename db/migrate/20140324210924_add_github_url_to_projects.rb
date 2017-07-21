class AddGithubUrlToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :github_url, :string
  end
end
