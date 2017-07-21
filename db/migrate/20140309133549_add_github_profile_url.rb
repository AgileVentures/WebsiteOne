class AddGithubProfileUrl < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :github_profile_url, :string
  end
end
