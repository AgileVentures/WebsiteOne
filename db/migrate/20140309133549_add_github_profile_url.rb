class AddGithubProfileUrl < ActiveRecord::Migration
  def change
    add_column :users, :github_profile_url, :string
  end
end
