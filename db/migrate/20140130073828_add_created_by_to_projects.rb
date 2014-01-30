class AddCreatedByToProjects < ActiveRecord::Migration
  def self.up
    add_index :projects, :user_id,
  end
end
