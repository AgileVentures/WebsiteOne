# frozen_string_literal: true

class AddCreatedByToDocuments < ActiveRecord::Migration[4.2]
  def self.up
    add_column :documents, :user_id, :integer
    add_index :documents, :user_id
  end

  def self.down
    remove_index :documents, :user_id
    remove_column :documents, :user_id
  end
end
