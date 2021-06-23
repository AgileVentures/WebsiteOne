# frozen_string_literal: true

class AddCreatedByToProjects < ActiveRecord::Migration[4.2]
  def self.up
    add_column :projects, :user_id, :integer
    add_index :projects, :user_id
  end

  def self.down
    remove_index :projects, :user_id
    remove_column :projects, :user_id
  end
end
