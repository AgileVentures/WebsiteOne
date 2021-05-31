# frozen_string_literal: true

class CreatePages < ActiveRecord::Migration[4.2]
  def change
    create_table :static_pages do |t|
      t.string :title
      t.text :body
      t.integer :parent_id
      t.string :slug

      t.timestamps
    end

    add_index :static_pages, :slug, unique: true
  end
end
