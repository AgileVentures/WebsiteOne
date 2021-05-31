# frozen_string_literal: true

class AddPitchToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :pitch, :string
  end
end
