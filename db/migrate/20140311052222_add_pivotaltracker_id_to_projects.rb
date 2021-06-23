# frozen_string_literal: true

class AddPivotaltrackerIdToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :pivotaltracker_id, :integer
  end
end
