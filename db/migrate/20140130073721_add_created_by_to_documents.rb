class AddCreatedByToDocuments < ActiveRecord::Migration[5.1]
  def self.up
    add_column :documents, :user_id, :integer
    add_index :documents, :user_id
  end
  def self.down
    remove_index :documents, :user_id
    remove_column :documents, :user_id
  end
end
