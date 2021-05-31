# frozen_string_literal: true

class AddGithubUrlToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :github_url, :string
  end
end
