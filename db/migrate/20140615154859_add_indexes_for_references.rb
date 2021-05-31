# frozen_string_literal: true

class AddIndexesForReferences < ActiveRecord::Migration[4.2]
  def change
    add_index :articles, :user_id
    add_index :documents, :project_id
    add_index :taggings, :tagger_id
    add_index :taggings, :tagger_type
  end
end
