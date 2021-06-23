# frozen_string_literal: true

class AddGithubProfileUrl < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :github_profile_url, :string
  end
end
