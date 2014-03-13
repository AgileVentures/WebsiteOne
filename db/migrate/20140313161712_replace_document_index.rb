class ReplaceDocumentIndex < ActiveRecord::Migration
  def change
    remove_index :documents, :slug
    add_index :documents, [:slug, :user_id], unique: true
  end
end
