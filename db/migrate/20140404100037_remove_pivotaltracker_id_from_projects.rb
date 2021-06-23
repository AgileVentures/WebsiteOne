# frozen_string_literal: true

class RemovePivotaltrackerIdFromProjects < ActiveRecord::Migration[4.2]
  def change
    remove_column :projects, :pivotaltracker_id
  end
end
