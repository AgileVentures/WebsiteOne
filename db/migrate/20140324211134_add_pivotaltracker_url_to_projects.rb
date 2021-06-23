# frozen_string_literal: true

class AddPivotaltrackerUrlToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :pivotaltracker_url, :string
  end
end
