# frozen_string_literal: true

class AddCommitCountToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :commit_count, :integer, default: 0
  end
end
