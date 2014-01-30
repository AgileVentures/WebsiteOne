class AddCreatedByToDocuments < ActiveRecord::Migration
  def self.up
    add_index :documents, :user_id,
  end
end
