class AddIndexesForReferences < ActiveRecord::Migration
  def change
    add_index :articles, :user_id
    add_index :documents, :project_id
    add_index :taggings, :tagger_id
    add_index :taggings, :tagger_type
  end
end
