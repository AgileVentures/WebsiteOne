# frozen_string_literal: true

class ReplaceDocumentIndex < ActiveRecord::Migration[4.2]
  def change
    remove_index :documents, :slug
    add_index :documents, %i(slug user_id), unique: true
  end
end
